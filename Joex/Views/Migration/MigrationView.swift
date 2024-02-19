//
//  MigrationView.swift
//  Joex
//
//  Created by Samuel Pitoňák on 05/02/2024.
//

import SwiftUI
import SwiftData

struct MigrationView: View {
    @Environment(\.modelContext)
    private var modelContext
    @Environment(\.dismiss)
    var dismiss
    
    @Query(filter: #Predicate<LogEntry> { logEntry in
        logEntry.isMigrated == false
    }, sort: \LogEntry.createdDate, order: .reverse)
    private var logEntries: [LogEntry]
    
    @AppStorage("dailyMigrationReminderTime")
    private var dailyMigrationReminderTime: TimeInterval = Date.now.timeIntervalSinceReferenceDate
    @AppStorage("dailyMigrationReminder")
    private var dailyMigrationReminder: Bool = false
    @AppStorage("deleteMigratedLogAfter")
    private var deleteMigratedLogAfter: String = DeleteMigratedLogAfter.ThreeDays.rawValue
    @AppStorage("migrationLogsCountBadge")
    private var migrationLogsCountBadge: Bool = false
    
    func handleClick() {
        if deleteMigratedLogAfter == DeleteMigratedLogAfter.Immediately.rawValue {
            modelContext.delete(logEntries.last!)
        } else {
            logEntries.last!.isMigrated = true
            logEntries.last!.migratedDate = .now
        }
        let descriptor = FetchDescriptor<LogEntry>(predicate: #Predicate { $0.isMigrated == false })
        let logEntriesCount = (try? modelContext.fetchCount(descriptor)) ?? 0
        scheduleMigrationNotification(logEntriesCount: logEntriesCount, notificationDate: Date(timeIntervalSinceReferenceDate: dailyMigrationReminderTime), dailyMigrationReminder: dailyMigrationReminder)
        updateWaitingLogsCountBadge(migrationLogsCountBadge: migrationLogsCountBadge, logEntriesCount: logEntriesCount)
    }
    
    var body: some View {
        if logEntries.last != nil {
            VStack {
                HStack {
                    Text(logEntries.last?.note ?? "")
                        .padding()
                    
                    Spacer()
                }
                
                Spacer()
                
                HStack {
                    Spacer()
                    
                    FabButtonView(handleClick: self.handleClick, icon: "checkmark", color: Color.green)
                        .padding([.bottom], -5)
                        .padding([.trailing], 20)
                }
            }
            .navigationTitle("Migration")
            .onDisappear {
                dismiss()
            }
        }
    }
}
