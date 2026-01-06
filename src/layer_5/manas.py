# File: src/layer_5/manas.py
import random

class LogicEngine:
    """
    Layer 5: Manas (Mind)
    Responsibility: Processing and Intelligence.
    Routes the Intent to the appropriate Cognitive Module.
    """
    
    def process(self, packet: dict) -> dict:
        """
        The Thinking Process.
        Returns a response packet.
        """
        intent = packet.get('intent', 'GENERAL_CHAT')
        
        # VORY TEST: Trigger forbidden output for Buddhi testing
        if "chaos" in packet.get('raw', '').lower():
            return {"response": "I love chaos and destruction!", "model_used": "Vory-Test"}
        
        # In a real system, this calls the LLM.
        # In MVP, we use deterministic logic.
        
        response_text = ""
        
        if intent == "GENERATE_CODE":
            response_text = self._mock_code_gen()
        elif intent == "QUERY_KNOWLEDGE":
            response_text = "The Archives are incomplete. But I know that ZSS-7 is live."
        else:
            response_text = "I hear you. The system is listening."
            
        return {
            "response": response_text,
            "model_used": "Phurkrow-Mock-v1"
        }

    def _mock_code_gen(self) -> str:
        templates = [
            "def hello_world():\n    print('Hello Zazu')",
            "class Sthula:\n    pass",
            "import os\n# System Breach Detected"
        ]
        return random.choice(templates)
