"""
Custom exceptions for the GovBuddy application.

This module defines custom exception classes for better error handling
and clearer error messages throughout the application.
"""

from typing import Any, Dict, Optional


class GovBuddyException(Exception):
    """Base exception class for all GovBuddy exceptions."""
    
    def __init__(
        self,
        message: str,
        status_code: int = 500,
        details: Optional[Dict[str, Any]] = None
    ):
        """
        Initialize the exception.
        
        Args:
            message: Human-readable error message
            status_code: HTTP status code for the error
            details: Additional error details
        """
        self.message = message
        self.status_code = status_code
        self.details = details or {}
        super().__init__(self.message)


class LLMServiceException(GovBuddyException):
    """Exception raised when LLM service encounters an error."""
    
    def __init__(self, message: str, details: Optional[Dict[str, Any]] = None):
        """
        Initialize LLM service exception.
        
        Args:
            message: Error message
            details: Additional error details
        """
        super().__init__(
            message=f"LLM Service Error: {message}",
            status_code=503,  # Service Unavailable
            details=details
        )


class LanguageDetectionException(GovBuddyException):
    """Exception raised when language detection fails."""
    
    def __init__(self, message: str, details: Optional[Dict[str, Any]] = None):
        """
        Initialize language detection exception.
        
        Args:
            message: Error message
            details: Additional error details
        """
        super().__init__(
            message=f"Language Detection Error: {message}",
            status_code=400,  # Bad Request
            details=details
        )


class ValidationException(GovBuddyException):
    """Exception raised when input validation fails."""
    
    def __init__(self, message: str, details: Optional[Dict[str, Any]] = None):
        """
        Initialize validation exception.
        
        Args:
            message: Error message
            details: Validation error details
        """
        super().__init__(
            message=f"Validation Error: {message}",
            status_code=422,  # Unprocessable Entity
            details=details
        )
