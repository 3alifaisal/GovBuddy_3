"""
Main entry point for the Backend application.

Responsibilities:
- Initializes the FastAPI instance.
- Configures Middleware (specifically CORS) to allow the Frontend to connect.
- Includes the API routers to expose endpoints.
- Starts the server and establishes the database connection.
"""


from fastapi import FastAPI

# creaitng the programm
app = FastAPI(title="GovPilot Bremen Backend")

# testing the web things
@app.get("/")
def read_root():
    return {"İts working"}