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
    
    @AppStorage("dailyMigrationReminderTime")
    private var dailyMigrationReminderTime: TimeInterval = Date.now.timeIntervalSinceReferenceDate
    @AppStorage("dailyMigrationReminder")
    private var dailyMigrationReminder: Bool = false
    @AppStorage("migrationLogsCountBadge")
    private var migrationLogsCountBadge: Bool = false
    
    @Parameter(title: "", inputOptions: String.IntentInputOptions.init(multiline: true))
    var note: String
    
    func perform() async throws -> some IntentResult {
        let schema = Schema([LogEntry.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        guard let modelContainer = try? ModelContainer(for: schema, configurations: [modelConfiguration]) else {
            return .result()
        }
        
        let logEntryNote = LogEntry(note: note)

        let modelContext = await modelContainer.mainContext

        modelContext.insert(logEntryNote)
        
        let descriptor = FetchDescriptor<LogEntry>(predicate: #Predicate { $0.isMigrated == false })
        
        let logEntriesCount = (try? modelContext.fetchCount(descriptor)) ?? 0
        
        scheduleMigrationNotification(logEntriesCount: logEntriesCount, notificationDate: Date(timeIntervalSinceReferenceDate: dailyMigrationReminderTime), dailyMigrationReminder: dailyMigrationReminder)
        
        updateWaitingLogsCountBadge(migrationLogsCountBadge: migrationLogsCountBadge, logEntriesCount: logEntriesCount)
        
        return .result()
    }
}
