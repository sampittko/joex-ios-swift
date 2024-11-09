import Foundation
import SwiftData

final class LogManager {
    static let shared = LogManager()
    
    private init() {}
    
    func autoDeleteExpiredLogs(deleteMigratedLogAfter: String, migratedLogEntries: [LogEntry], modelContext: ModelContext) {
        let now = Date.now
        for logEntry in migratedLogEntries {
            guard let migratedDate = logEntry.migratedDate else { continue }
            
            let daysSinceMigration = migratedDate.distance(to: now) / 86400
            if shouldDeleteLog(deleteAfter: deleteMigratedLogAfter, daysSinceMigration: daysSinceMigration) {
                modelContext.delete(logEntry)
            }
        }
    }
    
    private func shouldDeleteLog(deleteAfter: String, daysSinceMigration: Double) -> Bool {
        switch deleteAfter {
            case DeleteMigratedLogAfter.Immediately.rawValue: return true
            case DeleteMigratedLogAfter.OneDay.rawValue: return daysSinceMigration >= 1
            case DeleteMigratedLogAfter.ThreeDays.rawValue: return daysSinceMigration >= 3
            case DeleteMigratedLogAfter.OneWeek.rawValue: return daysSinceMigration >= 7
            case DeleteMigratedLogAfter.TwoWeeks.rawValue: return daysSinceMigration >= 14
            case DeleteMigratedLogAfter.OneMonth.rawValue: return daysSinceMigration >= 31
            default: return false
        }
    }
}
