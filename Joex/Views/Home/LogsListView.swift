import SwiftUI
import SwiftData
import FirebaseAnalytics

struct LogsListView: View {
    private static let EMPTY_LIST_MESSAGE = "List is empty 🥳"
    private static let MIGRATED_SECTION_TITLE = "Migrated"
    
    @Environment(\.modelContext) private var modelContext
    
    @Query(filter: #Predicate<LogEntry> { $0.isMigrated == true },
           sort: \LogEntry.createdDate, order: .reverse)
    private var migratedLogEntries: [LogEntry]
    
    @Query(filter: #Predicate<LogEntry> { $0.isMigrated == false },
           sort: \LogEntry.createdDate, order: .reverse)
    private var logEntries: [LogEntry]
    
    @AppStorage("dailyMigrationReminderTime")
    private var dailyMigrationReminderTime: TimeInterval = Date.now.timeIntervalSinceReferenceDate
    @AppStorage("dailyMigrationReminder")
    private var dailyMigrationReminder: Bool = false
    @AppStorage("migrationLogsCountBadge")
    private var migrationLogsCountBadge: Bool = false
    
    @State private var expandedMigratedLogEntries: Bool = false
    
    private func updateNotifications(after action: () -> Void) {
        action()
        let descriptor = FetchDescriptor<LogEntry>(predicate: #Predicate { $0.isMigrated == false })
        let logEntriesCount = (try? modelContext.fetchCount(descriptor)) ?? 0
        handleNotificationUpdates(
            logEntriesCount: logEntriesCount,
            notificationDate: Date(timeIntervalSinceReferenceDate: dailyMigrationReminderTime),
            dailyMigrationReminder: dailyMigrationReminder,
            migrationLogsCountBadge: migrationLogsCountBadge
        )
    }
    
    private var noEntriesSection: some View {
        HStack {
            Spacer()
            Text(Self.EMPTY_LIST_MESSAGE)
                .foregroundColor(.secondary)
            Spacer()
        }
    }
    
    private var activeEntriesSection: some View {
        Section {
            ForEach(logEntries) { logEntry in
                LogEntryView(logEntry: logEntry)
                    .swipeActions(allowsFullSwipe: false) {
                        Button("Delete", systemImage: "trash", role: .destructive) {
                            updateNotifications {
                                modelContext.delete(logEntry)
                                Analytics.logEvent("log_entry_deleted", parameters: [:])
                            }
                        }
                    }
            }
        }
    }
    
    private var migratedEntriesSection: some View {
        Section(isExpanded: $expandedMigratedLogEntries) {
            ForEach(migratedLogEntries) { logEntry in
                Text(logEntry.note)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                    .swipeActions(allowsFullSwipe: true) {
                        Button("Delete", systemImage: "trash", role: .destructive) {
                            Analytics.logEvent("migrated_log_entry_deleted", parameters: [:])
                            modelContext.delete(logEntry)
                        }
                        
                        Button("Recover", systemImage: "arrow.circlepath") {
                            updateNotifications {
                                Analytics.logEvent("migrated_log_entry_recovered", parameters: [:])
                                logEntry.isMigrated = false
                                logEntry.migratedDate = nil
                                logEntry.recoveredDate = .now
                            }
                        }
                    }
            }
        } header: {
            Text(Self.MIGRATED_SECTION_TITLE)
        }
    }
    
    var body: some View {
        List {
            if logEntries.isEmpty {
                noEntriesSection
            } else {
                activeEntriesSection
            }
            
            if migratedLogEntries.count > 0 {
                migratedEntriesSection
            }
        }
        .listStyle(.sidebar)
    }
}
