
from pydantic_settings import BaseSettings
from typing import Dict

class Settings(BaseSettings):
    ACADEMIC_CLOUD_API_KEY: str
    BASE_URL: str = "https://chat-ai.academiccloud.de/v1"
    MODEL: str = "llama-3.1-sauerkrautlm-70b-instruct"
    
    ARCANA_IDS: Dict[str, str] = {
        "anmeldung_und_meldebescheinigung": "ali.avada/anmeldung_und_meldebescheinigung",
        "fuehrerschein_und_verkehr": "ali.avada/fuehrerschein_und_verkehr",
        "wohnen_und_mietvertrag": "ali.avada/wohnen_und_mietvertrag",
        "krankenversicherung_und_gesundheit": "ali.avada/krankenversicherung_und_gesundheit",
        "arbeit_steuern_und_sozialversicherung": "ali.avada/arbeit_steuern_und_sozialversicherung",
        "studium_und_hochschule": "ali.avada/studium_und_hochschule"
    }

    class Config:
        env_file = ".env"

settings = Settings()