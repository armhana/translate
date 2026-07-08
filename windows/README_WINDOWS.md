# Live-Übersetzer auf Windows

Windows ist die vollständigste Plattform: Desktop-App **mit Live-Modus**
(Gespräche/Anrufe übersetzen) und Stimmklon (XTTS) **plus** Web-Server für
alle Geräte im WLAN. Alles läuft **lokal**; Inhalte verlassen den Rechner
nicht (Internet nur für den einmaligen Modell-Download).

## Installation (einmalig, 30–60 Minuten je nach Netz)

1. [Python 3.12](https://www.python.org/downloads/) installieren —
   dabei unbedingt **„Add python.exe to PATH"** ankreuzen
2. Dieses Repository holen — entweder:
   ```
   git clone https://github.com/armhana/translate-ai.git
   ```
   oder auf GitHub: *Code → Download ZIP* → entpacken
   (empfohlener Ort: direkt unter `C:\Users\<name>\`, **nicht** in
   OneDrive-Ordnern — die KI-Modelle sind mehrere GB groß)
3. **`Installieren.bat`** doppelklicken — richtet die Python-Umgebung ein
   und lädt die KI-Modelle (inkl. Stimmklon-Modell, 1,9 GB)

## Starten

| Datei | Zweck |
|---|---|
| **`Start.bat`** | Desktop-App: Video übersetzen, eigene Stimme, **Live-Modus** für Gespräche/Teams-Anrufe |
| **`Start-Server.bat`** | Web-Server: Konsole zeigt Adresse + QR-Code; iPhone/Android/Browser bedienen die App übers WLAN |

Endgeräte als App einrichten: siehe [APP-INSTALLATION.md](../APP-INSTALLATION.md).
Übersetzte Anrufe (Teams/Zoom): siehe [ANLEITUNG-ANRUF.md](../ANLEITUNG-ANRUF.md).

## Bekannte Stolpersteine

- **Firmen-Rechner:** Sicherheitssoftware (z. B. CrowdStrike) blockiert
  oft eingehende Verbindungen — dann erreichen Handys den Web-Server
  nicht ("Server antwortet nicht"). Lösung: IT um Freigabe von TCP-Port
  8710 bitten oder den Server auf Raspberry Pi/Mac betreiben.
  Am PC selbst funktioniert immer: `http://localhost:8710`
- **Firmen-Proxy:** TLS-Unterbrechung beim Modell-Download wird durch das
  eingebaute `truststore` automatisch gelöst (nutzt den
  Windows-Zertifikatspeicher).
- **Kein Ton?** In der Desktop-App den Knopf **🔔 Testton** neben der
  Geräteauswahl nutzen — er prüft den Tonweg ohne KI und zeigt Fehler an.
