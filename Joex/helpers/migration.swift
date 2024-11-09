import Foundation
import SwiftData

final class MigrationManager {
    // MARK: - Singleton
    static let shared = MigrationManager()
    private init() {}
    
    // MARK: - Auto Delete
    func handleMigratedLogsAutoDelete(deleteMigratedLogAfter: String, migratedLogEntries: [LogEntry], modelContext: ModelContext) {
        for logEntry in migratedLogEntries {
            var shouldDelete: Bool
            
            switch deleteMigratedLogAfter {
                case DeleteMigratedLogAfter.Immediately.rawValue:
                    shouldDelete = true
                case DeleteMigratedLogAfter.OneDay.rawValue:
                    shouldDelete = logEntry.migratedDate!.distance(to: Date.now) / 86400 >= 1
                case DeleteMigratedLogAfter.ThreeDays.rawValue:
                    shouldDelete = logEntry.migratedDate!.distance(to: Date.now) / 86400 >= 3
                case DeleteMigratedLogAfter.OneWeek.rawValue:
                    shouldDelete = logEntry.migratedDate!.distance(to: Date.now) / 86400 >= 7
                case DeleteMigratedLogAfter.TwoWeeks.rawValue:
                    shouldDelete = logEntry.migratedDate!.distance(to: Date.now) / 86400 >= 14
                case DeleteMigratedLogAfter.OneMonth.rawValue:
                    shouldDelete = logEntry.migratedDate!.distance(to: Date.now) / 86400 >= 31
                default:
                    shouldDelete = false
            }
            
            if shouldDelete == true {
                modelContext.delete(logEntry)
            }
        }
    }
}
