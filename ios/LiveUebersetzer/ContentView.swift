// ContentView.swift
// Hauptoberfläche: Video wählen → transkribieren → übersetzen → in eigener
// Stimme (Personal Voice) ausgeben, mit Play/Pause/Stopp/Spulen.
// ACHTUNG: Ungetestetes Starterprojekt — siehe README_iOS.md.

import SwiftUI
import PhotosUI
import Translation

struct ContentView: View {
    @State private var videoItem: PhotosPickerItem?
    @State private var videoURL: URL?
    @State private var transkript = ""
    @State private var uebersetzung = ""
    @State private var status = "Bereit."
    @State private var arbeitet = false

    // Zielsprache automatisch aus der Gerätesprache
    @State private var zielsprache = Locale.current.language.languageCode?.identifier ?? "de"
    @State private var eigeneStimme = true
    @State private var uebersetzungKonfig: TranslationSession.Configuration?

    @StateObject private var sprecher = Sprecher()
    private let erkenner = Transkribierer()

    private let sprachen = ["de", "en", "fr", "es", "it", "pt", "nl", "pl", "tr"]

    var body: some View {
        NavigationStack {
            Form {
                Section("1 · Video") {
                    PhotosPicker("Video aus Mediathek wählen",
                                 selection: $videoItem, matching: .videos)
                    if videoURL != nil {
                        Label("Video geladen", systemImage: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                    }
                }

                Section("2 · Sprache & Transkript") {
                    Picker("Zielsprache", selection: $zielsprache) {
                        ForEach(sprachen, id: \.self) { code in
                            Text(Locale.current.localizedString(forLanguageCode: code) ?? code)
                                .tag(code)
                        }
                    }
                    Button("Transkribieren & Übersetzen") { starteVerarbeitung() }
                        .disabled(videoURL == nil || arbeitet)
                    if !transkript.isEmpty {
                        Text(transkript).font(.callout).foregroundStyle(.secondary)
                    }
                }

                Section("3 · Übersetzung") {
                    if uebersetzung.isEmpty {
                        Text("—").foregroundStyle(.tertiary)
                    } else {
                        Text(uebersetzung).font(.callout)
                    }
                }

                Section("4 · Ausgabe") {
                    Toggle("Meine eigene Stimme (Personal Voice)", isOn: $eigeneStimme)
                    HStack(spacing: 18) {
                        Button { sprecher.spuleZurueck() } label: {
                            Image(systemName: "gobackward.10")
                        }
                        Button {
                            sprecher.playPause(text: uebersetzung,
                                               sprache: zielsprache,
                                               eigeneStimme: eigeneStimme)
                        } label: {
                            Image(systemName: sprecher.spielt ? "pause.circle.fill"
                                                              : "play.circle.fill")
                                .font(.largeTitle)
                        }
                        Button { sprecher.stopp() } label: {
                            Image(systemName: "stop.circle")
                        }
                        Button { sprecher.spuleVor() } label: {
                            Image(systemName: "goforward.10")
                        }
                    }
                    .buttonStyle(.borderless)
                    .disabled(uebersetzung.isEmpty)
                }

                Section { Text(status).font(.footnote).foregroundStyle(.secondary) }
            }
            .navigationTitle("Live-Übersetzer")
        }
        .onChange(of: videoItem) { ladeVideo() }
        // Apple-Übersetzungs-Framework: Session wird bereitgestellt, sobald
        // uebersetzungKonfig gesetzt wird (lädt ggf. Sprachpakete on-device).
        .translationTask(uebersetzungKonfig) { session in
            let text = transkript.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !text.isEmpty else {
                // Leere Anfragen lehnt Apple mit "translation request empty" ab
                status = "Keine Sprache im Video erkannt — bitte Video mit deutlicher Sprache wählen."
                arbeitet = false
                return
            }
            do {
                let antwort = try await session.translate(text)
                uebersetzung = antwort.targetText
                status = "Übersetzung fertig — mit ▶ anhören."
            } catch {
                status = "Übersetzung fehlgeschlagen: \(error.localizedDescription)"
            }
            arbeitet = false
        }
    }

    private func ladeVideo() {
        guard let item = videoItem else { return }
        status = "Lade Video…"
        Task {
            // Video als Datei in den App-Container kopieren
            if let daten = try? await item.loadTransferable(type: Data.self) {
                let ziel = FileManager.default.temporaryDirectory
                    .appendingPathComponent("eingabe.mov")
                try? daten.write(to: ziel)
                videoURL = ziel
                status = "Video bereit."
            } else {
                status = "Video konnte nicht geladen werden."
            }
        }
    }

    private func starteVerarbeitung() {
        guard let url = videoURL else { return }
        arbeitet = true
        status = "Transkribiere lokal…"
        Task {
            do {
                transkript = try await erkenner.transkribiere(videoURL: url)
                guard !transkript.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                    status = "Keine Sprache im Video erkannt — bitte Video mit deutlicher Sprache wählen."
                    arbeitet = false
                    return
                }
                status = "Übersetze lokal…"
                let quelle = Locale.Language(identifier:
                    Locale.current.language.languageCode?.identifier ?? "de")
                if quelle.languageCode?.identifier == zielsprache {
                    // Gleiche Sprache (Akzent entfernen): direkt übernehmen
                    uebersetzung = transkript
                    status = "Gleiche Sprache — Text übernommen, mit ▶ neu vertonen."
                    arbeitet = false
                } else if uebersetzungKonfig?.source?.languageCode?.identifier
                            == quelle.languageCode?.identifier,
                          uebersetzungKonfig?.target?.languageCode?.identifier == zielsprache {
                    // Gleiche Sprachrichtung wie zuvor: invalidate() erzwingt
                    // einen neuen Übersetzungslauf (sonst reagiert iOS nicht mehr)
                    uebersetzungKonfig?.invalidate()
                } else {
                    uebersetzungKonfig = TranslationSession.Configuration(
                        source: quelle,
                        target: Locale.Language(identifier: zielsprache))
                }
            } catch {
                status = "Fehler: \(error.localizedDescription)"
                arbeitet = false
            }
        }
    }
}
