import LocalAuthentication
import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.scenePhase) private var scenePhase
    
    @Query(filter: #Predicate<LogEntry> { $0.isMigrated == true }) private var migratedLogEntries: [LogEntry]
    @Query(filter: #Predicate<LogEntry> { $0.isMigrated == false }) private var logEntries: [LogEntry]
    
    @AppStorage("deleteMigratedLogAfter") private var deleteMigratedLogAfter: String = DeleteMigratedLogAfter.ThreeDays.rawValue
    
    @State private var newLogEntryNote: Bool = false
    @State private var newLogEntry: Bool = false
    
    var body: some View {
        VStack {
            NavigationStack {
                LogsListViewContainer(
                    newLogEntry: $newLogEntry,
                    newLogEntryNote: $newLogEntryNote,
                    logEntries: logEntries
                )
                .toolbar {
                    LogsToolbarView(isMigrationDisabled: logEntries.isEmpty)
                }
                .sheet(isPresented: $newLogEntryNote, onDismiss: resetNewLogEntryNote) {
                    NewLogEntryNoteView(
                        onDiscard: resetNewLogEntryNote,
                        onSave: resetNewLogEntryNote
                    )
                }
            }
        }
        .onChange(of: scenePhase) {
            handleScenePhaseChange()
        }
    }
    
    private func handleAutoDelete() {
        LogManager.shared.autoDeleteExpiredLogs(
            deleteMigratedLogAfter: deleteMigratedLogAfter,
            migratedLogEntries: migratedLogEntries,
            modelContext: modelContext
        )
    }
    
    private func handleScenePhaseChange() {
        if scenePhase == .active {
            handleAutoDelete()
        }
    }
    
    private func resetNewLogEntryNote() {
        newLogEntry = false
        newLogEntryNote = false
    }
}

struct LogsListViewContainer: View {
    @Binding var newLogEntry: Bool
    @Binding var newLogEntryNote: Bool
    var logEntries: [LogEntry]

    var body: some View {
        ZStack(alignment: .bottom) {
            LogsListView()
            NewLogEntryButtonView(newLogEntry: $newLogEntry, newLogEntryNote: $newLogEntryNote)
        }
        .navigationTitle("Logs")
    }
}

#Preview {
    ContentView()
        .modelContainer(for: LogEntry.self)
}
