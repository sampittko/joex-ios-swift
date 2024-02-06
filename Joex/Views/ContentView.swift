//
//  ContentView.swift
//  Joex
//
//  Created by Samuel Pitoňák on 28/01/2024.
//

import LocalAuthentication
import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.scenePhase) var scenePhase
    @State private var newNote: Bool = false
    @State private var newLogEntry: Bool = false
    @State private var authenticated = false
    
    func requestAuthentication() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "A way to protect log entries you enter into the application."
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                // authentication has now completed
                if success {
                    authenticated = true
                } else {
                    // there was a problem
                }
            }
        } else {
            // no biometrics
        }
    }
    
    func resetNewLogEntryNote() {
        newLogEntry = false
        newNote = false
    }
    
    var body: some View {
        VStack {
            if authenticated {
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
                        resetNewLogEntryNote()
                    }, content: {
                        NewLogEntryNoteView(
                            onDiscard: resetNewLogEntryNote,
                            onSave: resetNewLogEntryNote
                        )
                    })
                }
            }
        }
        .onChange(of: scenePhase, initial: true) { oldPhase, newPhase in
            if newPhase == .inactive {
                authenticated = false
            } else if newPhase == .background {
                authenticated = false
            } else if newPhase == .active && authenticated == false {
                requestAuthentication()
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: LogEntry.self)
}
