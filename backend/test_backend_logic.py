
import unittest
from unittest.mock import MagicMock, patch, AsyncMock
import asyncio
import sys
import os

# Mock pydantic_settings before importing app modules
sys.modules["pydantic_settings"] = MagicMock()
sys.modules["pydantic_settings"].BaseSettings = object

# Add backend to path
sys.path.append(os.path.join(os.path.dirname(__file__), 'app'))
sys.path.append(os.path.dirname(__file__))

# Import service
try:
    from app.services import llm_service
except ImportError:
    # If config fails to import, we might need to mock it
    sys.modules["app.core.config"] = MagicMock()
    from app.services import llm_service

# Create a mock settings object
mock_settings = MagicMock()
mock_settings.ACADEMIC_CLOUD_API_KEY = "test_key"
mock_settings.BASE_URL = "https://test.url"
mock_settings.MODEL = "test-model"
mock_settings.ARCANA_IDS = {
    "test_category": "test_arcana_id"
}

class TestBackendLogic(unittest.IsolatedAsyncioTestCase):
    
    async def test_get_response_success_with_arcana(self):
        """Test that it returns response when Arcana call succeeds."""
        mock_response = MagicMock()
        mock_response.status_code = 200
        mock_response.json.return_value = {"choices": [{"message": {"content": "Success"}}]}
        
        # Patch the settings in llm_service
        with patch("app.services.llm_service.settings", mock_settings):
            with patch("httpx.AsyncClient.post", new_callable=AsyncMock) as mock_post:
                mock_post.return_value = mock_response
                
                messages = [{"role": "user", "content": "Hello"}]
                category = "test_category"
                
                result = await llm_service.get_response(messages, category)
                
                self.assertEqual(result["choices"][0]["message"]["content"], "Success")
                # Verify Arcana was in payload
                call_kwargs = mock_post.call_args.kwargs
                self.assertIn("arcana", call_kwargs["json"])
                self.assertEqual(call_kwargs["json"]["arcana"]["id"], "test_arcana_id")

    async def test_get_response_fallback(self):
        """Test that it falls back to system prompt when Arcana call fails."""
        
        # First call fails, Second call succeeds
        mock_response_fail = MagicMock()
        mock_response_fail.status_code = 500
        # raise_for_status should raise an exception
        mock_response_fail.raise_for_status.side_effect = Exception("Arcana Failed")
        
        mock_response_success = MagicMock()
        mock_response_success.status_code = 200
        mock_response_success.json.return_value = {"choices": [{"message": {"content": "Fallback Success"}}]}
        mock_response_success.raise_for_status = MagicMock() # No error
        
        # Patch the settings in llm_service
        with patch("app.services.llm_service.settings", mock_settings):
            with patch("httpx.AsyncClient.post", new_callable=AsyncMock) as mock_post:
                mock_post.side_effect = [Exception("Arcana Failed"), mock_response_success]
                
                messages = [{"role": "user", "content": "Hello"}]
                category = "test_category"
                
                # Inject a test system prompt for this category
                from app.core.prompts import SYSTEM_PROMPTS
                SYSTEM_PROMPTS["test_category"] = "You are a test assistant."
                
                result = await llm_service.get_response(messages, category)
                
                self.assertEqual(result["choices"][0]["message"]["content"], "Fallback Success")
                
                # Verify two calls were made
                self.assertEqual(mock_post.call_count, 2)
                
                # Verify first call had Arcana
                first_call_kwargs = mock_post.call_args_list[0].kwargs
                self.assertIn("arcana", first_call_kwargs["json"])
                
                # Verify second call did NOT have Arcana and HAD system prompt
                second_call_kwargs = mock_post.call_args_list[1].kwargs
                self.assertNotIn("arcana", second_call_kwargs["json"])
                self.assertEqual(second_call_kwargs["json"]["messages"][0]["role"], "system")
                self.assertEqual(second_call_kwargs["json"]["messages"][0]["content"], "You are a test assistant.")

if __name__ == "__main__":
    unittest.main()
