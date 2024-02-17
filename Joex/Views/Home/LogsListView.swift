//
//  LogsListView.swift
//  Joex
//
//  Created by Samuel Pitoňák on 06/02/2024.
//

import SwiftUI
import SwiftData

struct LogsListView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var expandedMigratedLogEntries: Bool = false
    @Query(filter: #Predicate<LogEntry> { logEntry in
        logEntry.isMigrated == true
    }, sort: \LogEntry.createdDate, order: .reverse) private var logEntriesMigrated: [LogEntry]
    @Query(filter: #Predicate<LogEntry> { logEntry in
        logEntry.isMigrated == false
    }, sort: \LogEntry.createdDate, order: .reverse) private var logEntries: [LogEntry]
    
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
                                }
                            }
                    }
                })
            }
            
            if logEntriesMigrated.count > 0 {
                Section (isExpanded: $expandedMigratedLogEntries, content: {
                    ForEach(logEntriesMigrated) { logEntryMigrated in
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
                                }
                            }
                    }
                }, header: {
                    Text("Migrated logs")
                })
            }
        }
        .listStyle(.sidebar)
    }
}