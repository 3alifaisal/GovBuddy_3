from pydantic import BaseModel

class TranscriptionResponse(BaseModel):
    """Response model for transcription."""
    text: str
    
    class Config:
        json_schema_extra = {
            "example": {
                "text": "Hello, how do I register in Bremen?"
            }
        }
