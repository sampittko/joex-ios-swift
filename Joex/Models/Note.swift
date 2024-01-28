//
//  LogEntry.swift
//  Joex
//
//  Created by Samuel Pitoňák on 28/01/2024.
//

import Foundation
import SwiftData

@Model public class Note: LogEntry {
    @Attribute(.unique) public var id: String!
    public var created: Date
    public var migrated: Bool
    public var text: String
    
    init(text: String, created: Date = .now, migrated: Bool = false) {
        self.text = text
        self.created = created
        self.migrated = migrated
    }
}

