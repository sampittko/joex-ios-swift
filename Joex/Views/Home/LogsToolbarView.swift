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
        logEntry.isMigrated == false
    }) private var logEntries: [LogEntry]
    
    var body: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            NavigationLink(destination: SettingsView()) {
                Image(systemName: "gear")
                    .foregroundStyle(.gray)
            }
            .accessibilityLabel("Settings")
        }
        
        ToolbarItem(placement: .topBarTrailing) {
            NavigationLink(destination: MigrationView()) {
                Image(systemName: "book.pages")
            }
            .accessibilityLabel("Migration")
            .disabled(logEntries.isEmpty)
        }
    }
}
