import os
import sys

# Damit "import app" funktioniert, egal von wo aus pytest gestartet wird.
sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))
