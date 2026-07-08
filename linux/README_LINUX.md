# Live-Übersetzer auf Linux (Debian/Ubuntu)

Der Linux-Rechner übernimmt die Server-Rolle: Er rechnet die KI, alle
Geräte im Netz (iPhone, Android, PC) bedienen die Web-Oberfläche im
Browser. Alles läuft **lokal**; Inhalte verlassen das eigene Netz nicht
(Internet nur für den einmaligen Modell-Download).

## Installation (einmalig)

```bash
git clone https://github.com/armhana/translate-ai.git
cd translate-ai
bash linux/installieren-linux.sh
```

Das Skript installiert Systempakete (ffmpeg u. a.), richtet die
Python-Umgebung ein, lädt das Whisper-Modell vor und registriert einen
**systemd-Autostart-Dienst** — der Übersetzer läuft ab dann dauerhaft
und startet bei jedem Boot automatisch.

## Aufrufen

Von jedem Gerät im Netz: `http://<IP-des-Rechners>:8710`
(die IP zeigt das Skript am Ende an; wichtig: **http**, nicht https).
Endgeräte als App einrichten: siehe [APP-INSTALLATION.md](../APP-INSTALLATION.md).

## Dienst verwalten

```bash
sudo systemctl status uebersetzer     # Läuft er?
sudo systemctl restart uebersetzer    # Neu starten
journalctl -u uebersetzer -f          # Log ansehen
```

## Hinweise

- Whisper-Modell per Umgebungsvariable wählbar: vor der Installation
  `export WHISPER_MODELL=base` (schneller) oder `small` (genauer, Standard).
- Die Desktop-App (Tkinter) läuft ebenfalls: `venv/bin/python app/main.py`
  — ⚠️ auf Linux ungetestet.
- Eigene Stimme (XTTS): auf kräftigen x86-Rechnern nutzbar; auf schwacher
  Hardware praktisch zu langsam.
- Entwickelt auf Windows, auf Linux noch nicht ausgeführt — falls das
  Skript hakt: Fehlermeldung melden.
