
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.api.v1.endpoints import chat

app = FastAPI(title="GovPilot Bremen Backend")

# Configure CORS
origins = [
    "http://localhost:3000",
    "http://localhost:5000", # Flutter web default often uses this or similar, adding common ones
    "http://127.0.0.1:3000",
    "*" # For development simplicity, allowing all. In prod, restrict this.
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include Routers
app.include_router(chat.router, prefix="/api/v1")

@app.get("/")
def read_root():
    return {"message": "GovPilot Bremen Backend is running"}