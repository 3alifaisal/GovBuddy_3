"""
Manages direct interaction with the LLM (Llama 3.1 8B Instruct).
This service is used when RAG retrieval is not necessary (e.g., general chit-chat).
It handles:
- Formatting prompts to match the model's expected input structure.
- Processing and cleaning up the direct responses from the AI.

REFERENCE:
See Architecture Doc: "Llama 3.1 8B Instruct as main model"
"""