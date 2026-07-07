# Live-Übersetzer auf dem Mac (MacBook / iMac)

Der Mac übernimmt die Server-Rolle: Er rechnet die KI (inklusive
Stimmklon mit XTTS), und alle Geräte im WLAN — iPhone, Android, PC —
bedienen dieselbe Web-Oberfläche im Browser. Alles läuft **lokal** auf
dem Mac; Inhalte verlassen das eigene Netz nicht.

## Installation (einmalig, ca. 15–30 Minuten)

Voraussetzung: [Homebrew](https://brew.sh) ist installiert.
Dann im Terminal:

```bash
git clone https://github.com/armhana/translate.git
cd translate
bash mac/installieren-mac.sh
```

Das Skript installiert die Systempakete (ffmpeg, Python), richtet die
Python-Umgebung ein und lädt das Whisper-Modell vor. Weitere Modelle
(Übersetzung, Stimmen, XTTS) lädt die App beim ersten Gebrauch der
jeweiligen Funktion automatisch nach — reine Downloads, es werden keine
Inhalte hochgeladen.

## Starten

```bash
cd translate/app
../venv/bin/python web_server.py
```

Im Terminal erscheinen Adresse und QR-Code — am iPhone mit der Kamera
scannen oder `http://<Mac-IP>:8710` in Safari öffnen
(wichtig: **http**, nicht https).

Auf Apple-Silicon-Macs (M1–M4) läuft alternativ auch die native
iOS-App direkt auf dem Mac — siehe [ANLEITUNG-MAC-BUILD.md](../ios/ANLEITUNG-MAC-BUILD.md).

## Hinweise

- **Eigene Stimme (XTTS):** funktioniert auf dem Mac; Apple-Silicon-Macs
  sind dabei spürbar schneller als typische Büro-PCs.
- **Dauerbetrieb:** Terminalfenster einfach offen lassen; für Autostart
  einen launchd-Job einrichten (bei Bedarf melden).
- Dieses Setup wurde auf einem Windows-PC entwickelt und dort nicht auf
  einem echten Mac ausgeführt — falls das Skript hakt: Fehlermeldung
  kopieren und melden.
