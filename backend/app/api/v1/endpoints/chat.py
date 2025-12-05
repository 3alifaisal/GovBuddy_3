
from fastapi import APIRouter, HTTPException, Body
from pydantic import BaseModel
from typing import List, Dict
from app.services import llm_service

router = APIRouter()

class ChatRequest(BaseModel):
    messages: List[Dict[str, str]]
    category: str

@router.post("/ask")
async def ask_question(request: ChatRequest):
    """
    Endpoint to ask a question to the GovPilot Bremen AI.
    Accepts messages and a category.
    """
    # Validate category (simple check, though pydantic could do it with Enum)
    # The service handles the logic, but we can check if it exists in config if we wanted.
    # For now, we pass it through.
    
    try:
        response = await llm_service.get_response(request.messages, request.category)
        return response
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))