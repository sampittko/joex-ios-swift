//
//  SettingsView.swift
//  Joex
//
//  Created by Samuel Pitoňák on 17/02/2024.
//

import SwiftUI
import SwiftData

enum DeleteMigratedLogAfter: String, CaseIterable {
    case Immediately = "Migration"
    case OneDay = "1 day"
    case ThreeDays = "3 days"
    case OneWeek = "1 week"
    case TwoWeeks = "2 weeks"
    case OneMonth = "1 month"
}

enum AuthenticationTimeout: String, CaseIterable {
    case Immediately = "App close"
    case OneMinute = "1 minute"
    case FiveMinutes = "5 minutes"
    case FifteenMinutes = "15 minutes"
}

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(filter: #Predicate<LogEntry> { logEntry in
        logEntry.isMigrated == true
    }) private var logEntries: [LogEntry]
    @AppStorage("deleteMigratedLogAfter")
    private var deleteMigratedLogAfter: String = DeleteMigratedLogAfter.ThreeDays.rawValue
    @AppStorage("authenticationTimeout")
    private var authenticationTimeout: String = AuthenticationTimeout.Immediately.rawValue
    
    var body: some View {
        Form {
            Section("Migration") {
                Picker("Delete log after", selection: $deleteMigratedLogAfter) {
                    ForEach(DeleteMigratedLogAfter.allCases, id: \.self) { value in
                        Text(value.rawValue).tag(value.rawValue)
                    }
                }
            }
            Section("Privacy") {
                Picker("Lock app after", selection: $authenticationTimeout) {
                    ForEach(AuthenticationTimeout.allCases, id: \.self) { value in
                        Text(value.rawValue).tag(value.rawValue)
                    }
                }
            }
        }
        .navigationTitle("Settings")
        .onDisappear {
            updateMigratedLogsList(deleteMigratedLogAfter: deleteMigratedLogAfter, logEntries: logEntries, modelContext: modelContext)
        }
    }
}

#Preview {
    SettingsView()
}
