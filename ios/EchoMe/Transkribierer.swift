// Transkribierer.swift
// Extrahiert die Tonspur eines Videos und transkribiert sie on-device
// mit Apples Speech-Framework.
// ACHTUNG: Ungetestetes Starterprojekt — siehe README_iOS.md.

import AVFoundation
import Speech

struct Transkribierer {

    enum Fehler: LocalizedError {
        case keineBerechtigung, keinErkenner, exportFehlgeschlagen
        case keinOnDeviceModell, nichtsErkannt, keineTonspur
        var errorDescription: String? {
            switch self {
            case .keineBerechtigung: return "Spracherkennung nicht erlaubt (Einstellungen prüfen)."
            case .keinErkenner: return "Kein Erkenner für die Gerätesprache verfügbar."
            case .exportFehlgeschlagen: return "Tonspur konnte nicht extrahiert werden."
            case .keinOnDeviceModell: return
                "Lokales Diktatmodell fehlt. Bitte aktivieren: Einstellungen → " +
                "Allgemein → Tastatur → Diktat einschalten (Sprache Deutsch), " +
                "dann mit WLAN einige Minuten warten, bis das Modell geladen ist."
            case .nichtsErkannt: return
                "Keine Sprache im Video erkannt — bitte Video mit deutlicher " +
                "Sprache in der gewählten Videosprache verwenden."
            case .keineTonspur: return
                "Das Video hat keine Tonspur — beim Import ist der Ton verloren gegangen."
            }
        }
    }

    func transkribiere(videoURL: URL, sprache: Locale) async throws -> String {
        // 1) Berechtigung
        let statusOK = await withCheckedContinuation { cont in
            SFSpeechRecognizer.requestAuthorization { cont.resume(returning: $0 == .authorized) }
        }
        guard statusOK else { throw Fehler.keineBerechtigung }

        // 2) Tonspur als M4A exportieren
        let audioURL = FileManager.default.temporaryDirectory
            .appendingPathComponent("tonspur.m4a")
        try? FileManager.default.removeItem(at: audioURL)
        let asset = AVURLAsset(url: videoURL)
        // Ohne Tonspur "gelingt" der Export still mit Stille — vorher pruefen
        let tonspuren = try await asset.loadTracks(withMediaType: .audio)
        guard !tonspuren.isEmpty else { throw Fehler.keineTonspur }
        guard let export = AVAssetExportSession(asset: asset,
                                                presetName: AVAssetExportPresetAppleM4A) else {
            throw Fehler.exportFehlgeschlagen
        }
        export.outputURL = audioURL
        export.outputFileType = .m4a
        await export.export()
        guard export.status == .completed else { throw Fehler.exportFehlgeschlagen }

        // 3) On-Device-Erkennung in der GEWÄHLTEN Videosprache (nicht
        // zwingend die Gerätesprache — sonst findet ein z.B. englisch
        // eingestelltes iPhone in deutschen Videos nichts)
        guard let erkenner = SFSpeechRecognizer(locale: sprache),
              erkenner.isAvailable else { throw Fehler.keinErkenner }
        // Ohne lokales Diktatmodell liefert die Erkennung still NICHTS —
        // besser klar melden, was zu tun ist.
        guard erkenner.supportsOnDeviceRecognition else {
            throw Fehler.keinOnDeviceModell
        }
        let anfrage = SFSpeechURLRecognitionRequest(url: audioURL)
        anfrage.requiresOnDeviceRecognition = true   // nichts verlässt das Gerät
        anfrage.shouldReportPartialResults = true    // Zwischenstand als Auffangnetz
        anfrage.addsPunctuation = true

        let text: String = try await withCheckedThrowingContinuation { cont in
            var bester = ""     // bestes Zwischenergebnis merken
            var fertig = false  // Continuation darf nur EINMAL beantwortet werden
            erkenner.recognitionTask(with: anfrage) { ergebnis, fehler in
                guard !fertig else { return }
                if let ergebnis {
                    let t = ergebnis.bestTranscription.formattedString
                    if t.count > bester.count { bester = t }
                    if ergebnis.isFinal {
                        fertig = true
                        cont.resume(returning: t.isEmpty ? bester : t)
                        return
                    }
                }
                if let fehler {
                    fertig = true
                    // Wenn schon Text erkannt wurde, ist er wertvoller als der Fehler
                    if bester.isEmpty { cont.resume(throwing: fehler) }
                    else { cont.resume(returning: bester) }
                }
            }
        }
        guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw Fehler.nichtsErkannt
        }
        return text
    }
}
