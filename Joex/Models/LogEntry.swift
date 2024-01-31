//
//  LogEntry.swift
//  Joex
//
//  Created by Samuel Pitoňák on 28/01/2024.
//

import Foundation
import SwiftData

@Model class LogEntry {
    @Attribute(.unique) public var id: String!
    public var created: Date
    public var migrated: Bool
    public var note: String
    
    init(note: String, created: Date = .now, migrated: Bool = false) {
        self.note = note
        self.created = created
        self.migrated = migrated
    }
}

