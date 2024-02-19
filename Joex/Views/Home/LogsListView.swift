//
//  LogsListView.swift
//  Joex
//
//  Created by Samuel Pitoňák on 06/02/2024.
//

import SwiftUI
import SwiftData

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
                                    scheduleMigrationNotification(logEntriesCount: logEntries.count, notificationDate: Date(timeIntervalSinceReferenceDate: dailyMigrationReminderTime), dailyMigrationReminder: dailyMigrationReminder)
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
                            .swipeActions(allowsFullSwipe: false) {
                                Button("Delete", systemImage: "trash", role: .destructive) {
                                    modelContext.delete(logEntryMigrated)
                                }
                                
                                Button("Recover", systemImage: "arrow.circlepath") {
                                    logEntryMigrated.isMigrated = false
                                    logEntryMigrated.migratedDate = nil
                                    logEntryMigrated.recoveredDate = .now
                                    scheduleMigrationNotification(logEntriesCount: logEntries.count, notificationDate: Date(timeIntervalSinceReferenceDate: dailyMigrationReminderTime), dailyMigrationReminder: dailyMigrationReminder)
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
