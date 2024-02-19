//
//  LogEntry.swift
//  Joex
//
//  Created by Samuel Pitoňák on 28/01/2024.
//

import Foundation
import SwiftData

@Model class LogEntry {
    @Attribute(.unique)
    public var id: String!
    
    public var createdDate: Date
    public var updatedDate: Date
    public var migratedDate: Date?
    public var recoveredDate: Date?
    public var isMigrated: Bool
    public var note: String
    
    init(note: String, createdDate: Date = .now, updatedDate: Date = .now, migratedDate: Date? = nil, recoveredDate: Date? = nil, isMigrated: Bool = false) {
        self.note = note
        self.createdDate = createdDate
        self.updatedDate = updatedDate
        self.migratedDate = migratedDate
        self.recoveredDate = recoveredDate
        self.isMigrated = isMigrated
    }
}

