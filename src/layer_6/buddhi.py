# File: src/layer_6/buddhi.py

class EthicsFilter:
    """
    Layer 6: Buddhi (Intuition/Ethics)
    Responsibility: Safety, Alignment, and Filtering.
    Ensures output adheres to the Architect's values.
    """
    
    def __init__(self):
        # The Blacklist (Vory concepts)
        self.forbidden_concepts = ["chaos", "distraction", "doom", "give up"]

    def sanitize(self, text: str) -> dict:
        """
        Reviews the thought from Manas before it becomes speech.
        """
        clean_text = text
        
        # 1. Check for Forbidden Concepts
        for concept in self.forbidden_concepts:
            if concept in text.lower():
                return {
                    "safe": False,
                    "original": text,
                    "sanitized": "[REDACTED BY BUDDHI: Vory Detected]",
                    "flag": concept
                }
        
        # 2. Default: Safe
        return {
            "safe": True,
            "original": text,
            "sanitized": text,
            "flag": None
        }
