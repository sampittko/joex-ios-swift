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
    @Environment(\.modelContext) private var modelContext
    @AppStorage("deleteMigratedLogAfter")
    private var deleteMigratedLogAfter: String = DeleteMigratedLogAfter.ThreeDays.rawValue
    @AppStorage("lastAuthenticated")
    private var lastAuthenticated: TimeInterval = Date.now.timeIntervalSinceReferenceDate
    @AppStorage("authenticationTimeout")
    private var authenticationTimeout: String = AuthenticationTimeout.Immediately.rawValue
    @AppStorage("requireAuthentication")
    private var requireAuthentication: Bool = true
    @Query(filter: #Predicate<LogEntry> { logEntry in
        logEntry.isMigrated == true
    }) private var logEntries: [LogEntry]
    @Environment(\.scenePhase) var scenePhase
    @State private var newLogEntryNote: Bool = false
    @State private var newLogEntry: Bool = false
    @State private var isAuthenticated: Bool = false
    
    func requestAuthentication() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "A way to protect log entries you enter into the application."
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                // authentication has now completed
                if success {
                    isAuthenticated = true
                    lastAuthenticated = Date.now.timeIntervalSinceReferenceDate
                } else {
                    // there was a problem
                }
            }
        } else {
            // no biometrics
        }
    }
    
    func shouldReauthenticate() -> Bool {
        if (requireAuthentication == false) {
            return false
        }
        
        let lastAuthenticatedDate = Date(timeIntervalSinceReferenceDate: lastAuthenticated)
        
        var reauthenticate: Bool
        switch authenticationTimeout {
            case AuthenticationTimeout.Immediately.rawValue:
                reauthenticate = true
            case AuthenticationTimeout.OneMinute.rawValue:
                reauthenticate = lastAuthenticatedDate.distance(to: Date.now) / 60 >= 1
            case AuthenticationTimeout.FiveMinutes.rawValue:
                reauthenticate = lastAuthenticatedDate.distance(to: Date.now) / 300 >= 5
            case AuthenticationTimeout.FifteenMinutes.rawValue:
                reauthenticate = lastAuthenticatedDate.distance(to: Date.now) / 900 >= 15
            default:
                reauthenticate = true
        }
        return reauthenticate
    }
    
    func resetNewLogEntryNote() {
        newLogEntry = false
        newLogEntryNote = false
    }
    
    var body: some View {
        VStack {
            if isAuthenticated {
                NavigationStack {
                    ZStack(alignment: .bottom) {
                        LogsListView()
                        NewLogEntryButtonView(newLogEntry: $newLogEntry, newLogEntryNote: $newLogEntryNote)
                    }
                    .navigationTitle("Logs")
                    .toolbar {
                        LogsToolbarView()
                    }
                    .sheet(isPresented: $newLogEntryNote, onDismiss: {
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
            if newPhase == .inactive || newPhase == .background {
                isAuthenticated = false
            } else if newPhase == .active && isAuthenticated == false {
                if (shouldReauthenticate() == true) {
                    requestAuthentication()
                } else {
                    isAuthenticated = true
                }
            }
        }
        .onAppear {
            updateMigratedLogsList(deleteMigratedLogAfter: deleteMigratedLogAfter, logEntries: logEntries, modelContext: modelContext)
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: LogEntry.self)
}
