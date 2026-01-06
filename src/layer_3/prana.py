# File: src/layer_3/prana.py
import os

class ResourceManager:
    """
    Layer 3: Prana (Energy)
    Responsibility: Checks vital signs (API Keys, Quotas).
    """
    def __init__(self):
        # A hard Phurkrow limit to prevent "Vory" binges.
        self.daily_token_allowance = 5000 
        self.tokens_used = 0

    def check_vitality(self) -> dict:
        """
        Determines if the system has enough energy to process a request.
        """
        # 1. Check for the Divine Spark (API Key)
        # We don't crash yet if missing, just warn.
        api_key = os.getenv("OPENAI_API_KEY")
        
        # 2. Check Fatigue (Quotas)
        if self.tokens_used >= self.daily_token_allowance:
            return {
                "allowed": False, 
                "message": "PRANA DEPLETED. Rest required."
            }
        
        return {
            "allowed": True,
            "fuel_status": "ONLINE" if api_key else "OFFLINE (Mock Mode)",
            "current_load": f"{self.tokens_used}/{self.daily_token_allowance}"
        }

    def consume_energy(self, cost: int):
        """
        Drains Prana.
        """
        self.tokens_used += cost
