"""
Speech-to-text endpoint for audio transcription.

This module provides an endpoint for uploading audio files
and receiving text transcriptions.
"""

from fastapi import APIRouter, File, UploadFile, HTTPException, status
from pydantic import BaseModel
from app.services.speech_to_text_service import speech_to_text_service
from app.core.exceptions import LLMServiceException
from app.schemas.speech import TranscriptionResponse
import logging

logger = logging.getLogger(__name__)

# Create router for speech endpoints
router = APIRouter(prefix="/speech", tags=["speech"])


@router.post(
    "/transcribe",
    response_model=TranscriptionResponse,
    status_code=status.HTTP_200_OK,
    summary="Transcribe audio to text",
    description="Upload an audio file and receive a text transcription. Supports multiple audio formats."
)
async def transcribe_audio(
    audio: UploadFile = File(..., description="Audio file to transcribe (mp3, wav, m4a, webm)")
) -> TranscriptionResponse:
    """
    Transcribe an audio file to text.
    
    This endpoint:
    1. Validates the uploaded file
    2. Sends it to the speech-to-text service
    3. Returns the transcribed text
    
    Args:
        audio: Uploaded audio file
        
    Returns:
        TranscriptionResponse with the transcribed text
        
    Raises:
        HTTPException: If file is invalid or transcription fails
    """
    # Validate file type
    allowed_types = ["audio/mpeg", "audio/wav", "audio/m4a", "audio/webm", "audio/mp4"]
    if audio.content_type not in allowed_types:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Invalid file type. Allowed types: {', '.join(allowed_types)}"
        )
    
    # Check file size (max 25MB)
    max_size = 25 * 1024 * 1024  # 25MB
    contents = await audio.read()
    if len(contents) > max_size:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="File too large. Maximum size is 25MB"
        )
    
    try:
        # Create file-like object
        from io import BytesIO
        audio_file = BytesIO(contents)
        
        # Transcribe
        text = speech_to_text_service.transcribe_audio(
            audio_file,
            audio.filename or "audio.mp3"
        )
        
        return TranscriptionResponse(text=text)
        
    except LLMServiceException as e:
        raise
    except Exception as e:
        logger.error(f"Unexpected error in transcription endpoint: {e}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="An unexpected error occurred"
        )
