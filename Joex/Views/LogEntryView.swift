//
//  LogEntryView.swift
//  Joex
//
//  Created by Samuel Pitoňák on 28/01/2024.
//

import SwiftUI
import SwiftData

struct LogEntryView: View {
    public var logEntry: LogEntry

    var body: some View {
        Text(logEntry.note)
    }
}
