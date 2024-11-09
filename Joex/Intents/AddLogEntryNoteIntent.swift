//
//  AddLogEntryNoteIntent.swift
//  Joex
//
//  Created by Samuel Pitoňák on 04/02/2024.
//

import AppIntents
import SwiftUI
import SwiftData
import FirebaseAnalytics

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
        let modelContext = await SharedModelContainer.instance.mainContext
        
        let logEntryNote = LogEntry(note: note)

        modelContext.insert(logEntryNote)
        
        Analytics.logEvent("new_log_entry_note_added", parameters: ["shortcut": true])
        
        let descriptor = FetchDescriptor<LogEntry>(predicate: #Predicate { $0.isMigrated == false })
        
        let logEntries = (try? modelContext.fetch(descriptor)) ?? []
        
        NotificationsManager.shared.handleNotificationUpdates(
            logEntriesCount: logEntries.count,
            notificationDate: Date(timeIntervalSinceReferenceDate: dailyMigrationReminderTime),
            dailyMigrationReminder: dailyMigrationReminder,
            migrationLogsCountBadge: migrationLogsCountBadge
        )
        
        return .result()
    }
}
