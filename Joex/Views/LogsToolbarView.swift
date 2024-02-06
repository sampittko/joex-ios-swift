//
//  LogsToolbarView.swift
//  Joex
//
//  Created by Samuel Pitoňák on 06/02/2024.
//

import SwiftUI
import SwiftData

struct LogsToolbarView: ToolbarContent {
    @Query(filter: #Predicate<LogEntry> { logEntry in
        logEntry.migrated == false
    }, sort: \LogEntry.created, order: .reverse) private var logEntries: [LogEntry]
    
    var body: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            NavigationLink(destination: MigrationView(logEntries: logEntries)) {
                Image(systemName: "book.pages")
            }
            .accessibilityLabel("Migrate logs")
            .disabled(logEntries.isEmpty)
        }
    }
}
