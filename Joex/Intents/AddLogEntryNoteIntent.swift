//
//  AddLogEntryNoteIntent.swift
//  Joex
//
//  Created by Samuel Pitoňák on 04/02/2024.
//

import AppIntents
import SwiftUI
import SwiftData

struct AddLogEntryNoteIntent: AppIntent {
    static let title: LocalizedStringResource = "Add a note"
    
    @Query(filter: #Predicate<LogEntry> { logEntry in
        logEntry.isMigrated == false
    })
    private var logEntries: [LogEntry]
    
    @AppStorage("dailyMigrationReminderTime")
    private var dailyMigrationReminderTime: TimeInterval = Date.now.timeIntervalSinceReferenceDate
    @AppStorage("dailyMigrationReminder")
    private var dailyMigrationReminder: Bool = false
    
    @Parameter(title: "Note")
    var note: String
    
    func perform() async throws -> some IntentResult {
        let schema = Schema([LogEntry.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        guard let modelContainer = try? ModelContainer(for: schema, configurations: [modelConfiguration]) else {
            return .result()
        }

        let modelContext = await modelContainer.mainContext
        
        let logEntryNote = LogEntry(note: note)

        modelContext.insert(logEntryNote)
        
        scheduleMigrationNotification(logEntriesCount: logEntries.count, notificationDate: Date(timeIntervalSinceReferenceDate: dailyMigrationReminderTime), dailyMigrationReminder: dailyMigrationReminder)
        
        return .result()
    }
}
