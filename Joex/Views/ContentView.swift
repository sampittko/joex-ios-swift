//
//  ContentView.swift
//  Joex
//
//  Created by Samuel Pitoňák on 28/01/2024.
//

import LocalAuthentication
import SwiftUI
import SwiftData

struct VerticalLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack {
            configuration.icon.font(.headline)
            configuration.title.font(.footnote)
        }
    }
}

struct ContentView: View {
    @Environment(\.scenePhase) var scenePhase
    @State private var newNote: Bool = false
    @State private var newLogEntry: Bool = false
    @State private var note: String = ""
    @State private var isUnlocked = false
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "A way to protect log entries you enter into the application."
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                // authentication has now completed
                if success {
                    isUnlocked = true
                } else {
                    // there was a problem
                }
            }
        } else {
            // no biometrics
        }
    }
    
    var body: some View {
        VStack {
            if isUnlocked {
                NavigationStack {
                    ZStack(alignment: .bottom) {
                        LogsListView()
                        NewLogEntryButtonView(newLogEntry: $newLogEntry, newNote: $newNote)
                    }
                    .navigationTitle("Logs")
                    .toolbar {
                        LogsToolbarView()
                    }
                    .sheet(isPresented: $newNote, onDismiss: {
                        newLogEntry = false
                        newNote = false
                    }, content: {
                        NewLogEntryNoteView(note: $note, newLogEntry: $newLogEntry, newNote: $newNote)
                    })
                }
            }
        }
        .onChange(of: scenePhase, initial: true) { oldPhase, newPhase in
            if newPhase == .inactive {
                isUnlocked = false
            } else if newPhase == .background {
                isUnlocked = false
            } else if newPhase == .active && isUnlocked == false {
                authenticate()
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: LogEntry.self)
}
