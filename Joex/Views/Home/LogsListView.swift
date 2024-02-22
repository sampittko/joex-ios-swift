//
//  LogsListView.swift
//  Joex
//
//  Created by Samuel Pitoňák on 06/02/2024.
//

import SwiftUI
import SwiftData
import FirebaseAnalytics

struct LogsListView: View {
    @Environment(\.modelContext)
    private var modelContext
    
    @Query(filter: #Predicate<LogEntry> { logEntry in
        logEntry.isMigrated == true
    }, sort: \LogEntry.createdDate, order: .reverse)
    private var migratedLogEntries: [LogEntry]
    @Query(filter: #Predicate<LogEntry> { logEntry in
        logEntry.isMigrated == false
    }, sort: \LogEntry.createdDate, order: .reverse)
    private var logEntries: [LogEntry]
    
    @AppStorage("dailyMigrationReminderTime")
    private var dailyMigrationReminderTime: TimeInterval = Date.now.timeIntervalSinceReferenceDate
    @AppStorage("dailyMigrationReminder")
    private var dailyMigrationReminder: Bool = false
    @AppStorage("migrationLogsCountBadge")
    private var migrationLogsCountBadge: Bool = false
    
    @State
    private var expandedMigratedLogEntries: Bool = false
    
    var body: some View {
        List {
            if logEntries.isEmpty {
                HStack {
                    Spacer()
                    
                    Text("List is empty 🥳")
                        .foregroundColor(.secondary)
                    
                    Spacer()
                }
            } else {
                Section(content: {
                    ForEach(logEntries) { logEntry in
                        LogEntryView(logEntry: logEntry)
                            .swipeActions(allowsFullSwipe: false) {
                                Button("Delete", systemImage: "trash", role: .destructive) {
                                    modelContext.delete(logEntry)
                                    Analytics.logEvent("log_entry_deleted", parameters: [:])
                                    let descriptor = FetchDescriptor<LogEntry>(predicate: #Predicate { $0.isMigrated == false })
                                    let logEntriesCount = (try? modelContext.fetchCount(descriptor)) ?? 0
                                    scheduleMigrationNotification(logEntriesCount: logEntriesCount, notificationDate: Date(timeIntervalSinceReferenceDate: dailyMigrationReminderTime), dailyMigrationReminder: dailyMigrationReminder)
                                    updateWaitingLogsCountBadge(migrationLogsCountBadge: migrationLogsCountBadge, logEntriesCount: logEntriesCount)
                                }
                            }
                    }
                })
            }
            
            if migratedLogEntries.count > 0 {
                Section (isExpanded: $expandedMigratedLogEntries, content: {
                    ForEach(migratedLogEntries) { logEntryMigrated in
                        Text(logEntryMigrated.note)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                            .swipeActions(allowsFullSwipe: true) {
                                Button("Delete", systemImage: "trash", role: .destructive) {
                                    Analytics.logEvent("migrated_log_entry_deleted", parameters: [:])
                                    modelContext.delete(logEntryMigrated)
                                }
                                
                                Button("Recover", systemImage: "arrow.circlepath") {
                                    Analytics.logEvent("migrated_log_entry_recovered", parameters: [:])
                                    logEntryMigrated.isMigrated = false
                                    logEntryMigrated.migratedDate = nil
                                    logEntryMigrated.recoveredDate = .now
                                    let descriptor = FetchDescriptor<LogEntry>(predicate: #Predicate { $0.isMigrated == false })
                                    let logEntriesCount = (try? modelContext.fetchCount(descriptor)) ?? 0
                                    scheduleMigrationNotification(logEntriesCount: logEntriesCount, notificationDate: Date(timeIntervalSinceReferenceDate: dailyMigrationReminderTime), dailyMigrationReminder: dailyMigrationReminder)
                                    updateWaitingLogsCountBadge(migrationLogsCountBadge: migrationLogsCountBadge, logEntriesCount: logEntriesCount)
                                }
                            }
                    }
                }, header: {
                    Text("Migrated")
                })
            }
        }
        .listStyle(.sidebar)
    }
}
