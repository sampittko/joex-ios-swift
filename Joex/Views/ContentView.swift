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
                } else {
                    // there was a problem
                }
            }
        } else {
            // no biometrics
        }
    }
    
    func updateMigratedLogsList() {
        for logEntry in logEntries {
            var shouldDelete: Bool
            switch deleteMigratedLogAfter {
                case DeleteMigratedLogAfter.OneDay.rawValue:
                    shouldDelete = logEntry.migratedDate!.distance(to: Date.now) / 86400 >= 1
                case DeleteMigratedLogAfter.ThreeDays.rawValue:
                    shouldDelete = logEntry.migratedDate!.distance(to: Date.now) / 86400 >= 3
                case DeleteMigratedLogAfter.OneWeek.rawValue:
                    shouldDelete = logEntry.migratedDate!.distance(to: Date.now) / 86400 >= 7
                case DeleteMigratedLogAfter.OneMonth.rawValue:
                    shouldDelete = logEntry.migratedDate!.distance(to: Date.now) / 86400 >= 31
                default:
                    shouldDelete = false
            }
            if shouldDelete == true {
                modelContext.delete(logEntry)
            }
        }
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
                requestAuthentication()
            } else {
                updateMigratedLogsList()
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: LogEntry.self)
}
