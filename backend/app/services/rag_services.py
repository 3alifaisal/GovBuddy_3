"""
Core logic for the RAG (Retrieval-Augmented Generation) workflow.
Manages communication with the GWDG ChatAI RAG Manager.

Responsibilities:
- Sending user queries to the ChatAI API.
- Retrieving relevant documents from the hosted vector store.
- Processing and formatting the AI's response for the frontend.

REFERENCE:
See Architecture Doc: "ChatAI RAG Manager | Hosted vector store"
"""