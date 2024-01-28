//
//  LogEntry.swift
//  Joex
//
//  Created by Samuel Pitoňák on 28/01/2024.
//

import Foundation

protocol LogEntry {
    var id: String! {get}
    var created: Date {get set}
    var migrated: Bool {get set}
}

