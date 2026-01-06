# File: src/layer_7/atma.py
import sys

# Import the Lower 6 Layers
from src.layer_1.sthula import IOInterface
from src.layer_2.linga import SyntaxValidator
from src.layer_3.prana import ResourceManager
from src.layer_4.kama import IntentParser
from src.layer_5.manas import LogicEngine
from src.layer_6.buddhi import EthicsFilter

class ExecutiveController:
    """
    Layer 7: Atma (Spirit/Will)
    Responsibility: Orchestration and State.
    The 'I AM' of the system. It holds the lifecycle of the ZSS-7.
    """
    def __init__(self):
        # 1. Initialize the Septenary Stack
        self.sthula = IOInterface()       # Body
        self.linga = SyntaxValidator()    # Form
        self.prana = ResourceManager()    # Energy
        self.kama = IntentParser()        # Desire
        self.manas = LogicEngine()        # Mind
        self.buddhi = EthicsFilter()      # Conscience
        
        self.active = True
        self.session_id = "GENESIS-001"

    def ignite(self):
        """
        The Main Loop (formerly in main.py).
        """
        self.sthula.speak(f"ZSS-7 SYSTEMS FULLY ONLINE. Session: {self.session_id}")
        self.sthula.speak("All 7 Layers Operational. Ready to Build.")

        while self.active:
            # 1. Sthula (Input)
            raw = self.sthula.listen()
            
            # Kill Switch
            if raw.lower() in ["exit", "quit", "die"]:
                self.sthula.speak("Atma withdrawing. Om Tat Sat.")
                self.active = False
                break

            # 2. Linga (Validation)
            packet = self.linga.validate_input(raw)
            if not packet['valid']:
                self.sthula.error(packet['message'])
                continue

            # 3. Prana (Energy Check)
            vitality = self.prana.check_vitality()
            if not vitality['allowed']:
                self.sthula.error(vitality['message'])
                continue
            
            # Cost deducted
            self.prana.consume_energy(10)

            # 4. Kama (Intent)
            intent_packet = self.kama.parse(packet)

            # 5. Manas (Logic)
            thought = self.manas.process(intent_packet)

            # 6. Buddhi (Ethics)
            verdict = self.buddhi.sanitize(thought['response'])

            # 7. Atma (Execution/Output)
            if verdict['safe']:
                # The Spirit allows the Body to speak
                self.sthula.speak(verdict['sanitized'])
            else:
                self.sthula.error(f"ETHICS BLOCK: {verdict['flag']}")
                self.sthula.speak(verdict['sanitized'])
