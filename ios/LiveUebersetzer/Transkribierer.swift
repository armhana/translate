// Transkribierer.swift
// Extrahiert die Tonspur eines Videos und transkribiert sie on-device
// mit Apples Speech-Framework.
// ACHTUNG: Ungetestetes Starterprojekt — siehe README_iOS.md.

import AVFoundation
import Speech

struct Transkribierer {

    enum Fehler: LocalizedError {
        case keineBerechtigung, keinErkenner, exportFehlgeschlagen
        var errorDescription: String? {
            switch self {
            case .keineBerechtigung: return "Spracherkennung nicht erlaubt (Einstellungen prüfen)."
            case .keinErkenner: return "Kein Erkenner für die Gerätesprache verfügbar."
            case .exportFehlgeschlagen: return "Tonspur konnte nicht extrahiert werden."
            }
        }
    }

    func transkribiere(videoURL: URL) async throws -> String {
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
        guard let export = AVAssetExportSession(asset: asset,
                                                presetName: AVAssetExportPresetAppleM4A) else {
            throw Fehler.exportFehlgeschlagen
        }
        export.outputURL = audioURL
        export.outputFileType = .m4a
        await export.export()
        guard export.status == .completed else { throw Fehler.exportFehlgeschlagen }

        // 3) On-Device-Erkennung in der Gerätesprache
        guard let erkenner = SFSpeechRecognizer(locale: Locale.current),
              erkenner.isAvailable else { throw Fehler.keinErkenner }
        let anfrage = SFSpeechURLRecognitionRequest(url: audioURL)
        anfrage.requiresOnDeviceRecognition = true   // nichts verlässt das Gerät
        anfrage.shouldReportPartialResults = false

        return try await withCheckedThrowingContinuation { cont in
            erkenner.recognitionTask(with: anfrage) { ergebnis, fehler in
                if let fehler { cont.resume(throwing: fehler); return }
                if let ergebnis, ergebnis.isFinal {
                    cont.resume(returning: ergebnis.bestTranscription.formattedString)
                }
            }
        }
    }
}
