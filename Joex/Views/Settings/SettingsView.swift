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
    @AppStorage("requireAuthentication")
    private var requireAuthentication: Bool = true
    @AppStorage("dailyMigrationReminder")
    private var dailyMigrationReminder: Bool = false
    @AppStorage("dailyMigrationReminderTime")
    private var dailyMigrationReminderTime: TimeInterval = Date.now.timeIntervalSinceReferenceDate
    @State private var dailyMigrationReminderTimeState = Date.now
    
    var body: some View {
        Form {
            Section("Privacy") {
                Toggle("Require authentication", isOn: $requireAuthentication)
                    .disabled(true)
                if requireAuthentication {
                    Picker("Lock app after", selection: $authenticationTimeout) {
                        ForEach(AuthenticationTimeout.allCases, id: \.self) { value in
                            Text(value.rawValue).tag(value.rawValue)
                        }
                    }
                }
            }
            Section("Migration") {
                Picker("Delete log after", selection: $deleteMigratedLogAfter) {
                    ForEach(DeleteMigratedLogAfter.allCases, id: \.self) { value in
                        Text(value.rawValue).tag(value.rawValue)
                    }
                }
                Toggle("Daily reminder", isOn: $dailyMigrationReminder)
//                    .disabled(true)
                if dailyMigrationReminder {
                    DatePicker("Reminder time", selection: $dailyMigrationReminderTimeState , displayedComponents: .hourAndMinute)
                        .onChange(of: dailyMigrationReminderTimeState) { _, newDate in
                            dailyMigrationReminderTime = newDate.timeIntervalSinceReferenceDate
                        }
                }
            }
        }
        .navigationTitle("Settings")
        // Workaround from: https://www.hackingwithswift.com/forums/swiftui/dates-are-hard/24218/24246
        .onAppear {
            dailyMigrationReminderTimeState = Date(timeIntervalSinceReferenceDate: dailyMigrationReminderTime)
        }
        .onDisappear {
            updateMigratedLogsList(deleteMigratedLogAfter: deleteMigratedLogAfter, logEntries: logEntries, modelContext: modelContext)
        }
    }
}

#Preview {
    SettingsView()
}
