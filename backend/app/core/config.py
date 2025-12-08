from pydantic_settings import BaseSettings
from typing import Dict
from pathlib import Path
# Build paths inside the project like this: BASE_DIR / 'subdir'.
# config.py is in app/core/, so parent.parent.parent gets us to backend/
BASE_DIR = Path(__file__).resolve().parent.parent.parent

class Settings(BaseSettings):
    # API Config
    API_V1_STR: str = "/api/v1"
    PROJECT_NAME: str = "GovPilot Bremen Backend"
    
    ARCANA_IDS: Dict[str, str] = {
        "anmeldung_und_meldebescheinigung": "ali.avada/anmeldung_und_meldebescheinigung",
        "fuehrerschein_und_verkehr": "ali.avada/fuehrerschein_und_verkehr",
        "wohnen_und_mietvertrag": "ali.avada/wohnen_und_mietvertrag",
        "krankenversicherung_und_gesundheit": "ali.avada/krankenversicherung_und_gesundheit",
        "arbeit_steuern_und_sozialversicherung": "ali.avada/arbeit_steuern_und_sozialversicherung",
        "studium_und_hochschule": "ali.avada/studium_und_hochschule"
    }

    ACADEMIC_CLOUD_API_KEY: str = ""
    ACADEMIC_CLOUD_BASE_URL: str = "https://chat-ai.academiccloud.de/v1"
    ACADEMIC_CLOUD_MODEL_NAME: str = "meta-llama-3.1-8b-instruct"
    
    # Local Speech Config
    WHISPER_MODEL_SIZE: str = "base" # options: tiny, base, small, medium, large-v3

    class Config:
        # Explicitly point to the .env file in the backend directory
        env_file = str(BASE_DIR / ".env")
        case_sensitive = True

settings = Settings()

# Debugging
if settings.ACADEMIC_CLOUD_API_KEY:
    print(f"Loaded API Key: {settings.ACADEMIC_CLOUD_API_KEY[:5]}... (Length: {len(settings.ACADEMIC_CLOUD_API_KEY)})")
else:
    print(f"WARNING: No API Key loaded! Looking for .env at: {BASE_DIR / '.env'}")