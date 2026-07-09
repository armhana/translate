// VideoExporter.swift
// TODO-Gerüst: Originalvideo (Bild unverändert) mit neuer Tonspur exportieren.
// Vorgehen: Sprachausgabe mit AVSpeechSynthesizer.write(_:toBufferCallback:)
// in eine Audiodatei rendern, dann per AVMutableComposition die Original-
// Tonspur ersetzen und mit AVAssetExportSession als MP4 sichern.
// ACHTUNG: Ungetestetes Starterprojekt — siehe README_iOS.md.

import AVFoundation

struct VideoExporter {

    /// Ersetzt die Tonspur von `videoURL` durch `audioURL` und schreibt nach `zielURL`.
    func ersetzeTonspur(videoURL: URL, audioURL: URL, zielURL: URL) async throws {
        let komposition = AVMutableComposition()
        let video = AVURLAsset(url: videoURL)
        let audio = AVURLAsset(url: audioURL)

        guard let videoSpur = try await video.loadTracks(withMediaType: .video).first,
              let audioSpur = try await audio.loadTracks(withMediaType: .audio).first,
              let kVideo = komposition.addMutableTrack(withMediaType: .video,
                                                       preferredTrackID: kCMPersistentTrackID_Invalid),
              let kAudio = komposition.addMutableTrack(withMediaType: .audio,
                                                       preferredTrackID: kCMPersistentTrackID_Invalid)
        else { throw NSError(domain: "VideoExporter", code: 1) }

        let dauer = try await video.load(.duration)
        try kVideo.insertTimeRange(CMTimeRange(start: .zero, duration: dauer),
                                   of: videoSpur, at: .zero)
        let audioDauer = try await audio.load(.duration)
        try kAudio.insertTimeRange(CMTimeRange(start: .zero,
                                               duration: min(dauer, audioDauer)),
                                   of: audioSpur, at: .zero)

        guard let export = AVAssetExportSession(asset: komposition,
                                                presetName: AVAssetExportPresetHighestQuality)
        else { throw NSError(domain: "VideoExporter", code: 2) }
        export.outputURL = zielURL
        export.outputFileType = .mp4
        await export.export()
        guard export.status == .completed else {
            throw export.error ?? NSError(domain: "VideoExporter", code: 3)
        }
    }
}
