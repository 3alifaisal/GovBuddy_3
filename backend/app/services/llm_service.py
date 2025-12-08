import logging
import openai
from typing import List, Dict, Any, Optional
from app.core.config import settings
from app.core.prompts import SYSTEM_PROMPTS


logger = logging.getLogger(__name__)

# Initialize OpenAI Client (Best Practice: Initialize once)
client = openai.AsyncOpenAI(
    api_key=settings.ACADEMIC_CLOUD_API_KEY,
    base_url=settings.ACADEMIC_CLOUD_BASE_URL
)

async def get_response(messages: List[Dict[str, str]], category: str) -> Dict[str, Any]:
    """
    Sends a chat completion request to the external API using the official OpenAI SDK.
    
    Logic Flow:
    1. Detect Language.
    2. Inject System Prompt (always).
    3. Define attempts: 
       - If Arcana ID exists: [Try with Arcana, Try Standard Fallback]
       - If no Arcana ID: [Try Standard Only]
    4. Iterate and return first success.
    """
    

    # 2. Prepare Messages (System Prompt Injection)
    chat_messages = list(messages)
    system_prompt = SYSTEM_PROMPTS.get(category)
    if system_prompt:
        chat_messages.insert(0, {"role": "system", "content": system_prompt})

    # 3. Define Configurations
    arcana_id = settings.ARCANA_IDS.get(category)
    
    # Base arguments common to all calls
    base_kwargs = {
        "model": settings.ACADEMIC_CLOUD_MODEL_NAME,
        "messages": chat_messages,
        "temperature": 0.0,
        "top_p": 0.05,
    }

    configurations = []
    
    # Priority 1: Arcana call (if ID exists)
    if arcana_id:
        configurations.append({
            **base_kwargs,
            "extra_body": {
                "arcana": {"id": arcana_id, "key": ""}
            }
        })
        
    # Priority 2: Standard call (Fallback or Default)
    configurations.append(base_kwargs)

    # 4. Execute with Retry Logic
    last_exception = None
    
    for i, config in enumerate(configurations):
        is_last_attempt = (i == len(configurations) - 1)
        
        try:
            log_msg = f"Attempting call for category: {category}"
            if "extra_body" in config:
                log_msg += " (with Arcana)"
            else:
                log_msg += " (Standard/Fallback)"
            logger.info(log_msg)

            response = await client.chat.completions.create(**config)
            return response.model_dump()
            
        except openai.APIStatusError as e:
            last_exception = e
            logger.warning(f"Attempt failed with status {e.status_code}.")
            if is_last_attempt:
                logger.error("All attempts failed.")
                raise e
        except Exception as e:
            last_exception = e
            logger.warning(f"Attempt failed with error: {e}.")
            if is_last_attempt:
                logger.error("All attempts failed.")
                raise e
                
    # Should not be reached if list is not empty
    if last_exception:
        raise last_exception
    raise Exception("No configurations to execute")
