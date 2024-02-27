//
//  migration.swift
//  Joex
//
//  Created by Samuel Pitoňák on 17/02/2024.
//

import Foundation
import SwiftData

func migratedLogsAutoDelete(deleteMigratedLogAfter: String, migratedLogEntries: [LogEntry], modelContext: ModelContext) {
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
