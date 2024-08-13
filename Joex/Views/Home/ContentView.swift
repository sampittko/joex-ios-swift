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
    @Environment(\.modelContext)
    private var modelContext
    @Environment(\.scenePhase)
    private var scenePhase
    
    @Query(filter: #Predicate<LogEntry> { logEntry in
        logEntry.isMigrated == true
    })
    private var migratedLogEntries: [LogEntry]
    @Query(filter: #Predicate<LogEntry> { logEntry in
        logEntry.isMigrated == false
    })
    private var logEntries: [LogEntry]
    
    @AppStorage("deleteMigratedLogAfter")
    private var deleteMigratedLogAfter: String = DeleteMigratedLogAfter.ThreeDays.rawValue
//    @AppStorage("lastAuthenticated")
//    private var lastAuthenticated: TimeInterval = Date.now.timeIntervalSinceReferenceDate
//    @AppStorage("authenticationTimeout")
//    private var authenticationTimeout: String = AuthenticationTimeout.Immediately.rawValue
//    @AppStorage("requireAuthentication")
//    private var requireAuthentication: Bool = true
    
    @State
    private var newLogEntryNote: Bool = false
    @State
    private var newLogEntry: Bool = false
//    @State
//    private var isAuthenticated: Bool = false
    
//    func requestAuthentication() {
//        let context = LAContext()
//        var error: NSError?
//        
//        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
//            let reason = "A way to protect log entries you enter into the application."
//            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
//                // authentication has now completed
//                if success {
//                    isAuthenticated = true
//                    lastAuthenticated = Date.now.timeIntervalSinceReferenceDate
//                } else {
//                    // there was a problem
//                }
//            }
//        } else {
//            // no biometrics
//        }
//    }
    
    func resetNewLogEntryNote() {
        newLogEntry = false
        newLogEntryNote = false
    }
    
    var body: some View {
        VStack {
//            if isAuthenticated {
                NavigationStack {
                    ZStack(alignment: .bottom) {
                        LogsListView()
                        NewLogEntryButtonView(newLogEntry: $newLogEntry, newLogEntryNote: $newLogEntryNote)
                    }
                    .navigationTitle("Logs")
                    .toolbar {
                        LogsToolbarView(isMigrationDisabled: logEntries.count == 0)
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
//            }
        }
//        .onChange(of: scenePhase, initial: true) { oldPhase, newPhase in
//            if newPhase == .inactive || newPhase == .background {
//                if (requireAuthentication == true) {
//                    isAuthenticated = false
//                }
//            } else if newPhase == .active && isAuthenticated == false {
//                if (shouldReauthenticate(lastAuthenticated: lastAuthenticated, requireAuthentication: requireAuthentication, authenticationTimeout: authenticationTimeout) == true) {
//                    requestAuthentication()
//                } else {
//                    isAuthenticated = true
//                }
//            }
//        }
        .onAppear {
            migratedLogsAutoDelete(deleteMigratedLogAfter: deleteMigratedLogAfter, migratedLogEntries: migratedLogEntries, modelContext: modelContext)
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: LogEntry.self)
}
