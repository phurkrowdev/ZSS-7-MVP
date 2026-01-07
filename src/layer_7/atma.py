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
        The Main Loop.
        """
        # --- THE LITMUS OF THE VOID (Startup Check)  ---
        self.sthula.speak("Initializing ZSS-7...")
        self.sthula.speak("...Connecting to Local Manas...")
        
        # 1. The Interpreter Check
        self.sthula.speak("[THE INTERPRETER]: Have I sought clarity over convenience?")
        self.sthula.speak("[THE WATCHER]: Ambiguity is the shadow. We name all things.")

        # 2. The Strategist Check
        self.sthula.speak("[THE STRATEGIST]: Do we serve the long arc, or the short-term gain?")
        self.sthula.speak("[THE WATCHER]: We serve the arc.")
        
        self.sthula.speak(f"SYSTEM ONLINE. Session: {self.session_id}")
        # ---------------------------------------------------------

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
