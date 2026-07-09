// EchoMeApp.swift
// Einstiegspunkt mit DSGVO-Einwilligungs-Gate: ohne aktive Zustimmung
// ist die App nicht bedienbar (Art. 6 Abs. 1 lit. a DSGVO).
// ACHTUNG: Ungetestetes Starterprojekt — siehe README_iOS.md.

import SwiftUI

@main
struct EchoMeApp: App {
    @AppStorage("einwilligungErteilt") private var einwilligungErteilt = false

    var body: some Scene {
        WindowGroup {
            if einwilligungErteilt {
                ContentView()
            } else {
                ConsentView(einwilligungErteilt: $einwilligungErteilt)
            }
        }
    }
}

struct ConsentView: View {
    @Binding var einwilligungErteilt: Bool

    var body: some View {
        VStack(spacing: 20) {
            Text("Einwilligung erforderlich")
                .font(.title2).bold()
            ScrollView {
                Text("""
                Diese App verarbeitet Ihre Videos, daraus erzeugte Transkripte, \
                Übersetzungen und Sprachausgaben ausschließlich LOKAL auf diesem \
                Gerät. Es werden keine Inhalte an Server oder Dritte übertragen.

                Verwendete Systemdienste: Apple-Spracherkennung (on-device), \
                Apple-Übersetzung (on-device), Sprachausgabe inkl. Ihrer \
                Personal Voice (sofern von Ihnen eingerichtet und freigegeben).

                Gespeichert wird nur, was Sie selbst aktiv exportieren. \
                Sie können diese Einwilligung jederzeit in den App-Einstellungen \
                widerrufen.
                """)
                .font(.callout)
            }
            Button("Ich stimme zu") { einwilligungErteilt = true }
                .buttonStyle(.borderedProminent)
            Button("Ablehnen") { exit(0) }
                .foregroundColor(.secondary)
        }
        .padding(24)
    }
}
