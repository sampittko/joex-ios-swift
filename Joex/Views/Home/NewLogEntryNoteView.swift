//
//  NewLogEntryNoteView.swift
//  Joex
//
//  Created by Samuel Pitoňák on 06/02/2024.
//

import SwiftUI
import SwiftData

var INITIAL_NOTE: String = ""

struct NewLogEntryNoteView: View {
    @Environment(\.modelContext)
    private var modelContext
    
    @Query(filter: #Predicate<LogEntry> { logEntry in
        logEntry.isMigrated == false
    })
    private var logEntries: [LogEntry]
    
    @AppStorage("dailyMigrationReminderTime")
    private var dailyMigrationReminderTime: TimeInterval = Date.now.timeIntervalSinceReferenceDate
    @AppStorage("dailyMigrationReminder")
    private var dailyMigrationReminder: Bool = false
    @AppStorage("migrationLogsCountBadge")
    private var migrationLogsCountBadge: Bool = false
    
    @State
    private var note: String = INITIAL_NOTE;
    
    @FocusState
    private var keyboardFocused: Bool
    
    public var onDiscard: () -> Void
    public var onSave: () -> Void
    
    func createNoteLogEntry() {
        let logEntryNote = LogEntry(note: note)
        modelContext.insert(logEntryNote)
        scheduleMigrationNotification(logEntriesCount: logEntries.count, notificationDate: Date(timeIntervalSinceReferenceDate: dailyMigrationReminderTime), dailyMigrationReminder: dailyMigrationReminder)
        updateWaitingLogsCountBadge(migrationLogsCountBadge: migrationLogsCountBadge, logEntriesCount: logEntries.count)
    }
    
    func handleSave() {
        createNoteLogEntry()
        resetNote()
        onSave()
    }
    
    func handleDiscard() {
        resetNote()
        onDiscard()
    }
    
    func resetNote() {
        note = INITIAL_NOTE
    }
    
    var body: some View {
        NavigationView {
            VStack {
                TextEditor(text: $note)
                    .padding()
                    .focused($keyboardFocused)
                    .overlay {
                        if note.isEmpty {
                            Text("<- start typing")
                                .padding()
                                .position(x: 85, y: 33)
                                .opacity(0.25)
                        }
                    }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        handleDiscard()
                    }, label: {
                        Text("Discard")
                    })
                    .accessibilityLabel("Discard note")
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        handleSave()
                    }, label: {
                        Text("Save")
                    })
                    .disabled(note.isEmpty)
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.capsule)
                    .accessibilityLabel("Save note")
                }
            }
        }
        .onAppear {
            keyboardFocused = true
        }
    }
}
