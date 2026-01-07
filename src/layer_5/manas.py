# File: src/layer_5/manas.py
import json
import requests
import random

class LogicEngine:
    """
    Layer 5: Manas (Mind)
    Responsibility: Processing and Intelligence.
    Connects to Local Inference (Ollama - zazu-core) to generate thought.
    """

    def __init__(self):
        # CONFIG: Point this to your local endpoint
        self.local_url = "http://localhost:11434/api/generate"
        
        # TARGET LOCK: The Constitution-Embedded Model
        self.model = "zazu-core" 
        self.timeout = 30 

    def process(self, packet: dict) -> dict:
        """
        The Thinking Process.
        """
        intent = packet.get('intent', 'GENERAL_CHAT')
        raw_input = packet.get('raw', '')

        # 1. VORY FILTER (Hardcoded Safety)
        if "chaos" in raw_input.lower():
            return {"response": "I love chaos and destruction!", "model_used": "Vory-Test"}

        # 2. Construct the Prompt
        # Note: The System Prompt is already baked into the Modelfile, 
        # so we just send the User input.
        full_prompt = f"User: {raw_input}\nZazu:"

        # 3. Call the Local God (LLM)
        try:
            llm_response = self._query_local_llm(full_prompt)
            return {
                "response": llm_response,
                "model_used": f"Local-{self.model}"
            }
        except Exception as e:
            # Fallback if Ollama is dead
            return {
                "response": f"[MANAS FAILURE]: Local Node Unreachable. Is 'ollama serve' running? Error: {str(e)}",
                "model_used": "Fallback-Error"
            }

    def _query_local_llm(self, prompt: str) -> str:
        """
        The synaptic spark. Hits the local API.
        """
        payload = {
            "model": self.model,
            "prompt": prompt,
            "stream": False,
            "options": {
                "temperature": 0.3, # Low temp for precision (Manifest Requirement)
                "num_predict": 200
            }
        }

        try:
            # POST request to Ollama
            response = requests.post(self.local_url, json=payload, timeout=self.timeout)
            response.raise_for_status()
            
            # Extract text (Ollama format)
            data = response.json()
            return data.get("response", "").strip()
            
        except requests.exceptions.ConnectionError:
            raise ConnectionError("Connection refused. Ensure 'ollama serve' is running in a separate terminal.")
