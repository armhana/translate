#!/bin/bash
# ============================================================
#  EchoMe auf dem Mac (Apple Silicon oder Intel)
#  Richtet die VOLLE Desktop-App (wie unter Windows) UND den
#  optionalen Web-Server ein. Aufruf im geklonten Repo:
#      bash mac/installieren-mac.sh
#  Voraussetzung: Homebrew (https://brew.sh)
#  HINWEIS: ungetestet — auf einem Windows-PC geschrieben.
# ============================================================
set -e
cd "$(dirname "$0")/.."

echo "[1/4] Systempakete ueber Homebrew (ffmpeg, portaudio, python, tkinter)..."
command -v brew >/dev/null || { echo "Bitte zuerst Homebrew installieren: https://brew.sh"; exit 1; }
brew install ffmpeg portaudio python@3.12 python-tk@3.12

echo "[2/4] Python-Umgebung (volle App inkl. Stimmklon, mehrere GB)..."
python3.12 -m venv venv
venv/bin/pip install --upgrade pip
venv/bin/pip install --retries 10 -r mac/requirements-mac.txt

echo "[3/4] Whisper-Modell vorladen..."
venv/bin/python - <<'EOF'
from faster_whisper import WhisperModel
import os
WhisperModel("small", device="cpu", compute_type="int8",
             download_root=os.path.join("models", "whisper"))
print("Whisper small bereit.")
EOF

echo "[4/4] Doppelklick-Starter aktivieren..."
chmod +x mac/EchoMe-App.command mac/EchoMe-Server.command

echo ""
echo "=============================================================="
echo "  Fertig! Zwei unabhaengige Startwege:"
echo ""
echo "  DESKTOP-APP (wie Start.bat unter Windows):"
echo "      Doppelklick auf  mac/EchoMe-App.command"
echo "      (oder Terminal:  venv/bin/python app/main.py)"
echo ""
echo "  WEB-SERVER (nur falls iPhone & Co. diesen Mac nutzen sollen):"
echo "      Doppelklick auf  mac/EchoMe-Server.command"
echo "      dann am Handy:   http://<Mac-IP>:8710"
echo ""
echo "  Beim ersten Doppelklick: Rechtsklick -> Oeffnen (Gatekeeper)."
echo "=============================================================="
