# File: src/layer_2/linga.py
import datetime

class SyntaxValidator:
    """
    Layer 2: Linga (Blueprint/Subtle Body)
    Responsibility: Structure and Validation.
    Converts raw chaos (Sthula) into ordered forms (JSON/Dict).
    """
    
    def validate_input(self, raw_input: str) -> dict:
        """
        Takes raw string, injects entropy (time), and returns a 
        standardized schema.
        """
        # ISO 8601 Timestamp (The temporal anchor)
        timestamp = datetime.datetime.now().isoformat()

        # 1. Validation: Check for the Void (Empty Input)
        if not raw_input or not raw_input.strip():
            return {
                "timestamp": timestamp,
                "raw": None,
                "type": "error",
                "valid": False,
                "message": "Input Void Detected. The Blueprint requires substance."
            }

        # 2. Structural Packaging
        return {
            "timestamp": timestamp,
            "raw": raw_input,
            "type": "text",
            "valid": True
        }
