
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
    1. Attempt to use the 'arcana' parameter for the given category.
    2. If that fails (non-200 response), retry WITHOUT 'arcana' but WITH a specialized system prompt.
    """
    
    # Prepare the base payload
    payload = {
        "model": settings.MODEL,
        "messages": messages,
        "temperature": 0.0,
        "top_p": 0.05
    }
    
    headers = {
        "Content-Type": "application/json",
        "Authorization": f"Bearer {settings.ACADEMIC_CLOUD_API_KEY}"
    }
    
    arcana_id = settings.ARCANA_IDS.get(category)
    
    # --- Attempt 1: With Arcana ---
    if arcana_id:
        payload["arcana"] = {
            "id": arcana_id,
            "key": "" 
        }
        
    async with httpx.AsyncClient() as client:
        try:
            logger.info(f"Attempting Arcana call for category: {category}")
            # Use payload.copy() to avoid mutating the original payload for fallback if this fails
            response = await client.post(
                f"{settings.BASE_URL}/chat/completions",
                json=payload.copy(),
                headers=headers,
                timeout=60.0 
            )
            response.raise_for_status()
            return response.json()
            
        except httpx.HTTPStatusError as e:
            logger.warning(f"Arcana attempt failed with status {e.response.status_code}. Switching to fallback.")
        except Exception as e:
            logger.warning(f"Arcana attempt failed with error: {e}. Switching to fallback.")
            
    # --- Fallback: Without Arcana, with System Prompt ---
    # Remove arcana if it was added
    if "arcana" in payload:
        del payload["arcana"]
        
    # Inject system prompt
    system_prompt = SYSTEM_PROMPTS.get(category)
    if system_prompt:
        # Check if there is already a system prompt, if so replace it or prepend?
        # The user said: "Prepend a specialized System Prompt"
        # We will insert it at the beginning of the messages list.
        # However, we should be careful not to duplicate if the user already sent one (unlikely from frontend but possible)
        # We'll just insert it as the first message.
        payload["messages"].insert(0, {"role": "system", "content": system_prompt})
        
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