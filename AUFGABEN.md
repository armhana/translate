# Offene Aufgaben / Was noch zu tun ist

Stand: 07.07.2026

## Vom Nutzer zu erledigen

- [ ] **VB-Audio Virtual Cable installieren lassen** (IT anfragen, braucht
      Adminrechte) — Voraussetzung für übersetzte Teams/Zoom-Anrufe.
      Anleitung: [ANLEITUNG-ANRUF.md](ANLEITUNG-ANRUF.md)
- [ ] **Live-Modus mit echtem Mikrofon testen** (Desktop-App `Start.bat`,
      Tab „Live") — auf die Pegelanzeige achten
- [ ] **Teams-Testanruf** nach Cable-Installation durchspielen
      (Teams → Einstellungen → Geräte → „Testanruf führen")
- [ ] **Stimmklon-Qualität beurteilen**: eigenes Video mit den neuen,
      aufbereiteten Stimmprofilen erneut durchlaufen lassen

## Entwicklung (offen)

- [ ] **iOS-App kompilieren**: Swift-Starterprojekt unter `ios/` braucht
      einen Mac mit Xcode 16 — ungetestet
- [ ] **Linux-/Mac-/Raspberry-Pi-Skripte erstmalig ausführen**
      (`linux/`, `mac/`, `pi/`) — geschrieben auf Windows, noch nie auf
      Zielsystem gelaufen; Fehlermeldungen bitte melden
- [ ] Optional: **KI-Gesichtsverbesserung für Einzelfotos** (GFPGAN) —
      auf CPU machbar (~1 Min./Bild), auf Wunsch einbaubar
- [ ] Optional: **GPU-Beschleunigung** — mit NVIDIA-Grafikkarte liefe das
      Stimmklonen 10–20× schneller (Umstellung ist eine Codezeile)

## Bekannte Grenzen (kein Fehler, sondern Physik/Recht)

- Natives Handy-Telefonat kann keine App abgreifen (iOS/Android-Sperre)
- Stimmklon in Echtzeit unmöglich auf CPU — Live-Modus nutzt neutrale Stimme
- XTTS-Stimmklon-Lizenz: nur nicht-kommerzielle Nutzung
- Live-Übersetzung hat 2–5 s Versatz pro Satz
- Lange Videos mit eigener Stimme: ~1 Stunde Rechenzeit pro 15.000 Zeichen
