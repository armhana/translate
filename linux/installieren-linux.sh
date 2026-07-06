#!/bin/bash
# ============================================================
#  Live-Uebersetzer auf Linux (Debian/Ubuntu, x86_64 oder ARM64)
#  Richtet den Web-Server samt Autostart-Dienst ein.
#  Aufruf:   bash linux/installieren-linux.sh   (im geklonten Repo)
#  Danach:   http://<IP>:8710 von jedem Geraet im Netz
# ============================================================
set -e
cd "$(dirname "$0")/.."

echo "[1/4] Systempakete (ffmpeg, Python-venv, PortAudio)..."
sudo apt update
sudo apt install -y python3-venv python3-dev ffmpeg libportaudio2

echo "[2/4] Python-Umgebung..."
python3 -m venv venv
venv/bin/pip install --upgrade pip
venv/bin/pip install --retries 10 -r pi/requirements-pi.txt

echo "[3/4] Whisper-Modell vorladen..."
# Auf x86_64 ist 'small' gut nutzbar; auf schwacher Hardware 'base' waehlen.
MODELL="${WHISPER_MODELL:-small}"
venv/bin/python - <<EOF
from faster_whisper import WhisperModel
import os
WhisperModel("$MODELL", device="cpu", compute_type="int8",
             download_root=os.path.join("models", "whisper"))
print("Whisper $MODELL bereit.")
EOF

echo "[4/4] Autostart-Dienst einrichten..."
sudo tee /etc/systemd/system/uebersetzer.service >/dev/null <<EOF
[Unit]
Description=Live-Uebersetzer Web-Server
After=network-online.target

[Service]
Type=simple
User=$USER
WorkingDirectory=$(pwd)/app
Environment=WHISPER_MODELL=$MODELL
ExecStart=$(pwd)/venv/bin/python web_server.py
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable --now uebersetzer.service

IP=$(hostname -I | awk '{print $1}')
echo ""
echo "=============================================================="
echo "  Fertig! Web-Oberflaeche im Netz:  http://$IP:8710"
echo "  Desktop-App (Tkinter) alternativ: venv/bin/python app/main.py"
echo "  Status:  sudo systemctl status uebersetzer"
echo "=============================================================="
