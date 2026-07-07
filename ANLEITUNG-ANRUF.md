# Anleitung: Übersetzte Anrufe (Teams/Zoom) mit dem Live-Modus

Ziel: Du sprichst Deutsch — dein Gesprächspartner hört den Satz 2–5 Sekunden
später **akzentfrei in seiner Sprache** (neutrale Computerstimme). Was er sagt,
hörst du übersetzt auf deinem Kopfhörer.

## Einmalige Vorbereitung

### 1. VB-Audio Virtual Cable installieren (Adminrechte → ggf. IT fragen)
1. Von https://vb-audio.com/Cable/ das ZIP laden (kostenlos/Donationware)
2. Entpacken → `VBCABLE_Setup_x64.exe` **als Administrator** ausführen
3. Neu starten. Danach gibt es zwei neue Audiogeräte:
   - **CABLE Input** (Wiedergabegerät — hier hinein spricht unsere App)
   - **CABLE Output** (Aufnahmegerät — hieraus "hört" Teams)

### 2. Kopfhörer verwenden
Headset (z. B. Plantronics) statt Lautsprecher — sonst hört das Mikrofon
die Übersetzungen mit und es entsteht Chaos.

## Vor jedem Anruf

### In der Übersetzer-App (Start.bat → Tab „Live: Gespräch & Anruf")
| Einstellung | Wert |
|---|---|
| Meine Sprache | Deutsch (de) |
| Partnersprache | z. B. Englisch (en) |
| Mein Mikrofon | dein Headset-Mikrofon |
| Partner-Ton (Loopback) | dein **Headset** (dort kommt Teams-Ton an) |
| Ausgabe an mich (Kopfhörer) | dein Headset |
| **Ausgabe an Partner (virt. Kabel)** | **CABLE Input** |

Dann „▶ Live-Übersetzung starten" und die Einwilligungsfrage bestätigen —
**alle Gesprächsteilnehmer müssen vorher zugestimmt haben (§ 201 StGB).**

### In Teams/Zoom (Geräteeinstellungen)
| Einstellung | Wert |
|---|---|
| **Mikrofon** | **CABLE Output** ← der Partner hört NUR die Übersetzung |
| Lautsprecher | dein Headset |

## Ablauf im Gespräch

1. Sprich einen Satz und mach eine kurze Pause (~1 Sekunde).
2. Die App erkennt das Satzende, übersetzt und spricht die Übersetzung
   ins virtuelle Kabel → dein Partner hört sie.
3. Antworten des Partners werden vom Headset-Loopback erfasst und dir
   übersetzt ins Ohr gesprochen.
4. Alles Gesagte erscheint mitlesbar im Protokoll-Fenster.

## Vorher allein testen (ohne Partner)

Teams → Einstellungen → Geräte → **„Testanruf führen"**: Du hörst dann selbst,
was beim Partner ankommt. Alternativ Windows-Sprachrekorder mit Mikrofon
„CABLE Output" aufnehmen, während du sprichst.

## Grenzen (ehrlich)

- **2–5 Sekunden Versatz** pro Satz — Pausen machen hilft.
- Der Partner hört eine **neutrale Computerstimme**, nicht deine geklonte
  Stimme (Stimmklonen ist zu langsam für Echtzeit).
- Funktioniert für Anrufe **über den PC** — native Handy-Telefonate kann
  keine App abgreifen (Betriebssystem-Sperre von iOS/Android).
- Erkennungsqualität: bei wichtigen Gesprächen in der App „small (genauer)"
  wählen, wenn der Rechner es schafft.
