//
//  SettingsView.swift
//  Joex
//
//  Created by Samuel Pitoňák on 17/02/2024.
//

import SwiftUI
import SwiftData
import UserNotifications
import StoreKit
import FirebaseAnalytics

struct SettingsView: View {
    private var viewUuid: String = UUID().uuidString
    
    @Environment(\.modelContext)
    private var modelContext
    @Environment(\.requestReview)
    var requestReview
    
    @Query(filter: #Predicate<LogEntry> { logEntry in
        logEntry.isMigrated == true
    })
    private var migratedLogEntries: [LogEntry]
    @Query(filter: #Predicate<LogEntry> { logEntry in
        logEntry.isMigrated == false
    })
    private var logEntries: [LogEntry]

    @AppStorage("requireAuthentication")
    private var requireAuthentication: Bool = true
    @AppStorage("authenticationTimeout")
    private var authenticationTimeout: String = AuthenticationTimeout.Immediately.rawValue
    @AppStorage("deleteMigratedLogAfter")
    private var deleteMigratedLogAfter: String = DeleteMigratedLogAfter.ThreeDays.rawValue
    @AppStorage("dailyMigrationReminder")
    private var dailyMigrationReminder: Bool = false
    @AppStorage("dailyMigrationReminderTime")
    private var dailyMigrationReminderTime: TimeInterval = Date.now.timeIntervalSinceReferenceDate
    @AppStorage("migrationLogsCountBadge")
    private var migrationLogsCountBadge: Bool = false
    
    @State
    private var dailyMigrationReminderTimeState = Date.now
    
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
                        } else {
                            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["migration"])
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
            
            Button("Rate on App Store") {
                Analytics.logEvent("rate_on_app_store_click", parameters: [:])
                requestReview()
            }
            
            Button("Share feedback") {
                Analytics.logEvent("share_feedback_click", parameters: [:])
                UIApplication.shared.open(URL(string: "mailto:sampittko@gmail.com?subject=Joex Feedback")!)
            }
        }
        .navigationTitle("Settings")
        // Workaround from: https://www.hackingwithswift.com/forums/swiftui/dates-are-hard/24218/24246
        .onAppear {
            Analytics.logEvent(
                "settings_view_appeared",
                parameters: [
                    "view_instance_uuid": viewUuid,
                    "require_authentication": requireAuthentication,
                    "authentication_timeout": authenticationTimeout,
                    "delete_migrated_log_after": deleteMigratedLogAfter,
                    "daily_migration_reminder": dailyMigrationReminder,
                    "daily_migration_reminder_time": dailyMigrationReminderTime,
                    "migration_logs_count_badge": migrationLogsCountBadge
            ])
            dailyMigrationReminderTimeState = Date(timeIntervalSinceReferenceDate: dailyMigrationReminderTime)
        }
        .onDisappear {
            Analytics.logEvent(
                "settings_view_disappeared",
                parameters: [
                    "view_instance_uuid": viewUuid,
                    "require_authentication": requireAuthentication,
                    "authentication_timeout": authenticationTimeout,
                    "delete_migrated_log_after": deleteMigratedLogAfter,
                    "daily_migration_reminder": dailyMigrationReminder,
                    "daily_migration_reminder_time": dailyMigrationReminderTime,
                    "migration_logs_count_badge": migrationLogsCountBadge
                ]
            )
            updateMigratedLogsList(deleteMigratedLogAfter: deleteMigratedLogAfter, migratedLogEntries: migratedLogEntries, modelContext: modelContext)
        }
    }
}

#Preview {
    SettingsView()
}
