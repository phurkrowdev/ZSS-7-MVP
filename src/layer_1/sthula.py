import sys

class IOInterface:
    def __init__(self):
        self.active = True

    def listen(self) -> str:
        try:
            return input('ZAZU >> ').strip()
        except KeyboardInterrupt:
            self.speak('System Interrupt. Om Tat Sat.')
            sys.exit(0)

    def speak(self, output: str) -> None:
        print(f'\n[ZAZU]: {output}\n')

    def error(self, message: str) -> None:
        print(f'\n[ERROR]: {message}\n')
