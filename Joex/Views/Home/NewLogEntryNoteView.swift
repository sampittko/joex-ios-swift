import SwiftUI
import SwiftData
import FirebaseAnalytics

// Constants
private let INITIAL_NOTE = ""

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
        let descriptor = FetchDescriptor<LogEntry>(predicate: #Predicate { $0.isMigrated == false })
        let logEntriesCount = (try? modelContext.fetchCount(descriptor)) ?? 0
        NotificationsManager.shared.handleNotificationUpdates(
            logEntriesCount: logEntriesCount,
            notificationDate: Date(timeIntervalSinceReferenceDate: dailyMigrationReminderTime),
            dailyMigrationReminder: dailyMigrationReminder,
            migrationLogsCountBadge: migrationLogsCountBadge
        )
    }
    
    func handleSave() {
        Analytics.logEvent("new_log_entry_note_added", parameters: ["shortcut": false])
        createNoteLogEntry()
        resetNote()
        onSave()
    }
    
    func handleDiscard() {
        Analytics.logEvent("new_log_entry_note_discarded", parameters: [:])
        resetNote()
        onDiscard()
    }
    
    func resetNote() {
        note = INITIAL_NOTE
    }
    
    private var SaveButton: some View {
        Button(action: handleSave) {
            Text("Save")
        }
        .disabled(note.isEmpty)
        .buttonStyle(.borderedProminent)
        .buttonBorderShape(.capsule)
        .accessibilityLabel("Save note")
    }
    
    private var DiscardButton: some View {
        Button(action: handleDiscard) {
            Text("Discard")
        }
        .accessibilityLabel("Discard note")
    }
    
    var body: some View {
        NavigationView {
            VStack {
                TextEditor(text: $note)
                    .padding()
                    .focused($keyboardFocused)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    DiscardButton
                }
                ToolbarItem(placement: .topBarTrailing) {
                    SaveButton
                }
            }
        }
        .onAppear {
            keyboardFocused = true
        }
    }
}
