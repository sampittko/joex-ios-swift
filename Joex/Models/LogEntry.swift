//
//  LogEntry.swift
//  Joex
//
//  Created by Samuel Pitoňák on 28/01/2024.
//

import Foundation
import SwiftData

enum LogEntryType: String, Codable {
    case Note = "note"
    case VoiceMemo = "voice_memo"
}

@Model class LogEntry {
    @Attribute(.unique) public var id: String!
    public var type: LogEntryType
    public var created: Date
    public var migrated: Bool
    public var note: String?
    public var voiceMemo: String?
    
    init(note: String, created: Date = .now, migrated: Bool = false) {
        self.type = LogEntryType.Note
        self.note = note
        self.voiceMemo = nil
        self.created = created
        self.migrated = migrated
    }
    
    init(voiceMemo: String, created: Date = .now, migrated: Bool = false) {
        self.type = LogEntryType.VoiceMemo
        self.note = nil
        self.voiceMemo = voiceMemo
        self.created = created
        self.migrated = migrated
    }
}

