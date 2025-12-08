"""
Main API Router.
Groups all our endpoints (like chat and speech) together.
Keeps our URL structure clean (e.g., /api/v1/chat).
"""

from fastapi import APIRouter
from app.api.v1.endpoints import chat, speech

api_router = APIRouter()

api_router.include_router(chat.router, tags=["chat"])
api_router.include_router(speech.router, tags=["speech"])