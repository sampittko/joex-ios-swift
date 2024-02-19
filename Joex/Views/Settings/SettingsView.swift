//
//  SettingsView.swift
//  Joex
//
//  Created by Samuel Pitoňák on 17/02/2024.
//

import SwiftUI
import SwiftData
import UserNotifications

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
    }) private var migratedLogEntries: [LogEntry]
    @Query(filter: #Predicate<LogEntry> { logEntry in
        logEntry.isMigrated == false
    }) private var logEntries: [LogEntry]
    @AppStorage("deleteMigratedLogAfter")
    private var deleteMigratedLogAfter: String = DeleteMigratedLogAfter.ThreeDays.rawValue
    @AppStorage("authenticationTimeout")
    private var authenticationTimeout: String = AuthenticationTimeout.Immediately.rawValue
    @AppStorage("requireAuthentication")
    private var requireAuthentication: Bool = true
    @AppStorage("dailyMigrationReminder")
    private var dailyMigrationReminder: Bool = false
    @AppStorage("migrationLogsCountBadge")
    private var migrationLogsCountBadge: Bool = false
    @AppStorage("dailyMigrationReminderTime")
    private var dailyMigrationReminderTime: TimeInterval = Date.now.timeIntervalSinceReferenceDate
    @State private var dailyMigrationReminderTimeState = Date.now
    
    var body: some View {
        Form {
            Section("Privacy") {
                Toggle("Require authentication", isOn: $requireAuthentication)
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
            }
            Section("Notifications") {
                Toggle("Daily migration reminder", isOn: $dailyMigrationReminder)
                    .onChange(of: dailyMigrationReminder) { oldValue, newValue in
                        if (newValue == true) {
                            let newDate = Date.now
                            dailyMigrationReminderTime = newDate.timeIntervalSinceReferenceDate
                            dailyMigrationReminderTimeState = newDate
                            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                                if error != nil {
                                    dailyMigrationReminder = false
                                }
                            }
                        }
                    }
                if dailyMigrationReminder {
                    DatePicker("Migration reminder time", selection: $dailyMigrationReminderTimeState , displayedComponents: .hourAndMinute)
                        .onChange(of: dailyMigrationReminderTimeState) { _, newDate in
                            dailyMigrationReminderTime = newDate.timeIntervalSinceReferenceDate
                            scheduleMigrationNotification(logEntriesCount: logEntries.count, notificationDate: newDate, dailyMigrationReminder: dailyMigrationReminder)
                        }
                        .onAppear {
                            UIDatePicker.appearance().minuteInterval = 15
                        }
                }
                Toggle("Waiting logs count badge", isOn: $migrationLogsCountBadge)
                    .onChange(of: migrationLogsCountBadge) { oldValue, newValue in
                        if (newValue == true) {
                            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                                if success {
                                    UNUserNotificationCenter.current().setBadgeCount(logEntries.count)
                                }
                                if error != nil {
                                    migrationLogsCountBadge = false
                                }
                            }
                        } else {
                            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                                if success {
                                    UNUserNotificationCenter.current().setBadgeCount(0)
                                }
                            }
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
            updateMigratedLogsList(deleteMigratedLogAfter: deleteMigratedLogAfter, logEntries: migratedLogEntries, modelContext: modelContext, dailyMigrationReminderTime: dailyMigrationReminderTime, dailyMigrationReminder: dailyMigrationReminder)
        }
    }
}

#Preview {
    SettingsView()
}
