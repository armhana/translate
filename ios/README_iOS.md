# iOS-Starterprojekt „Live-Übersetzer"

**Status: ungetestetes Grundgerüst.** Dieser Code wurde auf einem Windows-PC
geschrieben und konnte dort weder kompiliert noch ausgeführt werden. Er dient
als Startpunkt für die Entwicklung auf einem Mac.

## Architektur — alles on-device, kein Server nötig

| Funktion | Apple-Framework | Mindest-iOS |
|---|---|---|
| Spracherkennung (Video → Text) | `Speech` (SFSpeechRecognizer, on-device) | 17 |
| Übersetzung | `Translation` (on-device) | 18 |
| Sprachausgabe | `AVSpeechSynthesizer` | 17 |
| **Eigene Stimme** | **Personal Voice** (vom Nutzer selbst in den iOS-Einstellungen trainiert) | 17 |

Personal Voice ist Apples datenschutzkonforme Antwort auf Stimmklonen: Der
Nutzer erstellt seine Stimme selbst unter *Einstellungen → Bedienungshilfen →
Personal Voice*; Apps erhalten nur mit expliziter Zustimmung Zugriff.

## Voraussetzungen

- Mac mit Xcode 16 oder neuer
- iPhone mit iOS 18 (Übersetzungs-Framework)
- Apple-ID (kostenlos fürs eigene Gerät; App-Store-Verteilung: Developer-Programm, 99 €/Jahr)

## Projekt aufsetzen

1. Xcode → *File → New → Project → iOS App*, Name `LiveUebersetzer`,
   Interface **SwiftUI**, Sprache **Swift**.
2. Die Dateien aus `ios/LiveUebersetzer/` in das Projekt ziehen
   (die von Xcode erzeugten `ContentView.swift`/`…App.swift` ersetzen).
3. In den Target-Einstellungen → *Info* diese Schlüssel ergänzen:
   - `NSSpeechRecognitionUsageDescription` — „Transkribiert Ihre Videos lokal."
   - `NSPhotoLibraryUsageDescription` — „Wählt das zu übersetzende Video aus."
4. *Signing & Capabilities*: eigenes Team wählen, auf dem iPhone ausführen.
5. Auf dem iPhone einmalig Personal Voice erstellen
   (*Einstellungen → Bedienungshilfen → Personal Voice*, ~15 Min. Training)
   und beim ersten App-Start den Zugriff erlauben.

## Bekannte Grenzen

- **Telefonate können auf iOS grundsätzlich nicht abgegriffen werden** —
  das Betriebssystem erlaubt keiner App Zugriff auf den Anrufton.
- Personal Voice spricht am natürlichsten in der Sprache, in der sie
  trainiert wurde; fremdsprachige Ausgabe klingt ggf. akzentbehaftet.
- Die On-Device-Übersetzung erfordert einmalig das Laden der Sprachpakete
  durch iOS (Systemdialog beim ersten Gebrauch).
- Video-Export mit neuer Tonspur ist im Gerüst als TODO markiert
  (AVMutableComposition; Grundgerüst in `VideoExporter.swift`).
