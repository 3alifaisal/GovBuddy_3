"""
Speech-to-text service for audio transcription.

This service uses a local instance of Faster-Whisper to transcribe audio files
into text, running entirely on the CPU (or GPU if available) for privacy and zero cost.
"""

from typing import BinaryIO
from faster_whisper import WhisperModel
from app.core.config import settings
from app.core.exceptions import LLMServiceException
import logging
import tempfile
import os
import shutil
import time
import logging
import io

import torch

logger = logging.getLogger(__name__)


class SpeechToTextService:
    """
    Service for transcribing audio to text using a local Whisper model.
    """
    
    def __init__(self):
        """Initialize the speech-to-text service."""
        try:
            # 1. Detect Device (GPU vs CPU)
            device = "cuda" if torch.cuda.is_available() else "cpu"
            
            # 2. Select Compute Type
            # GPU supports float16 for speed. CPU usually runs better on int8.
            compute_type = "float16" if device == "cuda" else "int8"
            
            logger.info(f"Initializing Local Whisper Model ({settings.WHISPER_MODEL_SIZE}) on {device.upper()} with {compute_type} precision...")
            
            # Initialize model
            self.model = WhisperModel(
                settings.WHISPER_MODEL_SIZE, 
                device=device, 
                compute_type=compute_type
            )
            
            logger.info(f"Speech-to-text service initialized successfully (Local on {device.upper()})")
        except Exception as e:
            logger.error(f"Failed to initialize local speech-to-text service: {e}")
            raise LLMServiceException(
                "Failed to initialize speech service",
                details={"error": str(e)}
            )
    
    def transcribe_audio(self, audio_file: BinaryIO, filename: str) -> str:
        """
        Transcribe audio file to text.
        
        Args:
            audio_file: Binary audio file content (file-like object)
            filename: Name of the audio file (used for extension detection if needed)
            
        Returns:
            Transcribed text
        """
        start_total = time.time()
        try:
            # 1. Processing in Memory 
            # Read all bytes into RAM
            if hasattr(audio_file, "seek"):
                audio_file.seek(0)
            
            audio_bytes = audio_file.read()
            audio_stream = io.BytesIO(audio_bytes)
            
            logger.info(f"Transcribing audio from memory ({len(audio_bytes)} bytes)")
            
            # 2. Transcribe
            # faster-whisper supports file-like objects
            segments, info = self.model.transcribe(
                audio_stream, 
                beam_size=5,
                language=None, # Auto-detect language
                initial_prompt="Hier wird Deutsch oder Englisch gesprochen. This is German or English." # Bias for DE/EN
            )
            
            start_gen = time.time()
            # 3. Collect text segments
            # segments is a generator, so we must iterate
            text_segments = []
            for segment in segments:
                text_segments.append(segment.text)
                
            full_text = " ".join(text_segments).strip()
            
            logger.info(
                f"Transcription successful",
                extra={
                    "detected_language": info.language,
                    "text_length": len(full_text)
                }
            )
            
            end_total = time.time()
            gen_duration = end_total - start_gen
            total_duration = end_total - start_total
            
            # Print performance metrics explicitly for user debugging
            print(f"PERFORMANCE [SpeechToText]: Total Duration: {total_duration:.4f}s")
            print(f"PERFORMANCE [SpeechToText]: Generator Consumption: {gen_duration:.4f}s (Realtime factor: unknown)")
            
            return full_text
            
        except Exception as e:
            logger.error(f"Transcription failed: {e}", exc_info=True)
            raise LLMServiceException(
                "Failed to transcribe audio. Please try again.",
                details={"error": str(e)}
            )
        finally:
             pass


# Singleton instance
speech_to_text_service = SpeechToTextService()
