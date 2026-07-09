# EchoMe auf dem Mac (MacBook / iMac)

Der Mac ist **vollständig eigenständig** — wie der Windows-PC: eigene
Desktop-App (Video übersetzen, eigene Stimme per XTTS-Stimmklon,
Live-Modus) und optional ein Web-Server für andere Geräte. Alles läuft
**lokal** auf dem Mac; Inhalte verlassen das eigene Netz nicht.

## Installation (einmalig, ca. 20–40 Minuten)

Voraussetzung: [Homebrew](https://brew.sh) ist installiert.
Dann im Terminal:

```bash
git clone https://github.com/armhana/echome-ai.git
cd echome-ai
bash mac/installieren-mac.sh
```

Das Skript installiert die Systempakete (ffmpeg, Python, Tkinter),
richtet die Python-Umgebung mit allen Funktionen ein (inkl. Stimmklon)
und lädt das Whisper-Modell vor. Weitere Modelle lädt die App beim
ersten Gebrauch automatisch nach — reine Downloads, es werden keine
Inhalte hochgeladen.

## Starten — zwei unabhängige Wege

**1. Desktop-App** (das Gegenstück zu `Start.bat` unter Windows —
der Mac braucht dafür keinen Server und kein anderes Gerät):

> Doppelklick auf **`mac/EchoMe-App.command`**
> (oder Terminal: `venv/bin/python app/main.py`)

Beim allerersten Doppelklick verlangt macOS: **Rechtsklick → Öffnen**
(Gatekeeper-Bestätigung), danach genügt der normale Doppelklick.

**2. Web-Server** — nur nötig, wenn **andere** Geräte (iPhone, Android)
diesen Mac als Übersetzer nutzen sollen:

> Doppelklick auf **`mac/EchoMe-Server.command`**

Im Terminal erscheinen Adresse und QR-Code — am iPhone scannen oder
`http://<Mac-IP>:8710` in Safari öffnen (wichtig: **http**, nicht https).

Auf Apple-Silicon-Macs (M1–M4) läuft zusätzlich die native iOS-App
direkt auf dem Mac — siehe [ANLEITUNG-MAC-BUILD.md](../ios/ANLEITUNG-MAC-BUILD.md).

## Hinweise

- **Eigene Stimme (XTTS):** funktioniert in der Desktop-App und im
  Server; Apple-Silicon-Macs sind dabei spürbar schneller als typische
  Büro-PCs.
- **Live-Modus auf dem Mac:** Mikrofon-Richtung funktioniert; die
  Partner-Richtung (Systemton mithören) unterstützt macOS ohne
  Zusatztreiber nicht — dafür z. B. BlackHole installieren.
- **Dauerbetrieb des Servers:** Terminalfenster offen lassen; für
  Autostart einen launchd-Job einrichten (bei Bedarf melden).
- Dieses Setup wurde auf einem Windows-PC entwickelt und dort nicht auf
  einem echten Mac ausgeführt — falls etwas hakt: Fehlermeldung
  kopieren und melden.
