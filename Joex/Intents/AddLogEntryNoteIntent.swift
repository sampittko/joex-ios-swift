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
    
    @Parameter(title: "Note")
    var note: String
    
    func perform() async throws -> some IntentResult & ProvidesDialog {
        let schema = Schema([LogEntry.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        guard let modelContainer = try? ModelContainer(for: schema, configurations: [modelConfiguration]) else {
            return .result(dialog: "Failed to add a note")
        }

        let context = await modelContainer.mainContext
        
        let logEntryNote = LogEntry(note: note)

        context.insert(logEntryNote)
        
        return .result(dialog: "Note added")
    }
}
