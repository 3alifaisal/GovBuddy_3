import httpx
import logging
from typing import List, Dict, Any
from app.core.config import settings
from app.core.prompts import SYSTEM_PROMPTS

logger = logging.getLogger(__name__)

async def get_response(messages: List[Dict[str, str]], category: str) -> Dict[str, Any]:
    """
    Sends a chat completion request to the external API.
    
    Logic Flow:
    1. Inject System Prompt (always).
    2. Attempt to use the 'arcana' parameter for the given category.
    3. If that fails (non-200 response), retry WITHOUT 'arcana' (but still with System Prompt).
    """
    
    # Prepare the base payload
    # Create a copy of messages to avoid side effects when inserting system prompt
    payload = {
        "model": settings.MODEL,
        "messages": list(messages),
        "temperature": 0.0,
        "top_p": 0.05
    }
    
    headers = {
        "Content-Type": "application/json",
        "Authorization": f"Bearer {settings.ACADEMIC_CLOUD_API_KEY}"
    }
    
    # --- Step 1: Inject System Prompt ---
    system_prompt = SYSTEM_PROMPTS.get(category)
    if system_prompt:
        payload["messages"].insert(0, {"role": "system", "content": system_prompt})
    
    # --- Step 2: Attempt with Arcana (if available) ---
    arcana_id = settings.ARCANA_IDS.get(category)
    
    if arcana_id:
        payload["arcana"] = {
            "id": arcana_id,
            "key": "" 
        }
        
        async with httpx.AsyncClient() as client:
            try:
                logger.info(f"Attempting Arcana call for category: {category}")
                response = await client.post(
                    f"{settings.BASE_URL}/chat/completions",
                    json=payload,
                    headers=headers,
                    timeout=60.0 
                )
                response.raise_for_status()
                return response.json()
                
            except httpx.HTTPStatusError as e:
                logger.warning(f"Arcana attempt failed with status {e.response.status_code}. Switching to fallback.")
            except Exception as e:
                logger.warning(f"Arcana attempt failed with error: {e}. Switching to fallback.")
        
        # If we are here, Arcana failed. Remove the key for fallback.
        if "arcana" in payload:
            del payload["arcana"]
            
    # --- Step 3: Fallback (Without Arcana, but WITH System Prompt) ---
    async with httpx.AsyncClient() as client:
        try:
            logger.info(f"Attempting Fallback call for category: {category}")
            response = await client.post(
                f"{settings.BASE_URL}/chat/completions",
                json=payload,
                headers=headers,
                timeout=60.0
            )
            response.raise_for_status()
            return response.json()
        except Exception as e:
            logger.error(f"Fallback attempt also failed: {e}")
            raise e