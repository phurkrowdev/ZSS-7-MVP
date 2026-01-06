# File: src/layer_4/kama.py

class IntentParser:
    """
    Layer 4: Kama (Desire)
    Responsibility: Decodes the 'Why'. 
    Classifies raw text into Actionable Intents.
    """
    
    def parse(self, packet: dict) -> dict:
        """
        Enriches the data packet with an 'intent' field.
        """
        raw_text = packet['raw'].lower()
        
        # 1. Heuristic: Code Generation Desire
        if any(word in raw_text for word in ["write", "generate", "code", "function", "class"]):
            packet['intent'] = "GENERATE_CODE"
            packet['confidence'] = 0.9
            
        # 2. Heuristic: Knowledge Retrieval Desire
        elif "?" in raw_text or any(word in raw_text for word in ["what", "how", "why", "explain"]):
            packet['intent'] = "QUERY_KNOWLEDGE"
            packet['confidence'] = 0.8
            
        # 3. Default: Conversational Desire
        else:
            packet['intent'] = "GENERAL_CHAT"
            packet['confidence'] = 0.5
            
        return packet
