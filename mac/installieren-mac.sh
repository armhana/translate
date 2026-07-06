#!/bin/bash
# ============================================================
#  Live-Uebersetzer auf dem Mac (Apple Silicon oder Intel)
#  Richtet den Web-Server ein; Aufruf im geklonten Repo:
#      bash mac/installieren-mac.sh
#  Voraussetzung: Homebrew (https://brew.sh)
#  HINWEIS: ungetestet — auf einem Windows-PC geschrieben.
# ============================================================
set -e
cd "$(dirname "$0")/.."

echo "[1/3] Systempakete ueber Homebrew (ffmpeg, portaudio, python)..."
command -v brew >/dev/null || { echo "Bitte zuerst Homebrew installieren: https://brew.sh"; exit 1; }
brew install ffmpeg portaudio python@3.12

echo "[2/3] Python-Umgebung..."
python3.12 -m venv venv
venv/bin/pip install --upgrade pip
venv/bin/pip install --retries 10 -r pi/requirements-pi.txt

echo "[3/3] Whisper-Modell vorladen..."
venv/bin/python - <<'EOF'
from faster_whisper import WhisperModel
import os
WhisperModel("small", device="cpu", compute_type="int8",
             download_root=os.path.join("models", "whisper"))
print("Whisper small bereit.")
EOF

echo ""
echo "=============================================================="
echo "  Fertig! Server starten mit:"
echo "      cd app && ../venv/bin/python web_server.py"
echo "  Dann von jedem Geraet im Netz:  http://<Mac-IP>:8710"
echo "  (Dauerbetrieb: launchd-Job oder einfach Terminal offen lassen)"
echo "=============================================================="
