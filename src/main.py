# File: src/main.py
import sys
import os

# --- TITANIUM FIX: Path Resolution ---
current_dir = os.path.dirname(os.path.abspath(__file__))
project_root = os.path.dirname(current_dir)
if project_root not in sys.path:
    sys.path.insert(0, project_root)
# -------------------------------------

# Import only the Spirit
from src.layer_7.atma import ExecutiveController

def main():
    try:
        # Ignite the Atma
        zazu = ExecutiveController()
        zazu.ignite()
    except KeyboardInterrupt:
        print("\n[Hard Interrupt]")
        sys.exit(0)
    except Exception as e:
        print(f"CRITICAL FAILURE: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()
