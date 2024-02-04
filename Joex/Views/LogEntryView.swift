//
//  LogEntryView.swift
//  Joex
//
//  Created by Samuel Pitoňák on 28/01/2024.
//

import SwiftUI
import SwiftData

struct LogEntryView: View {
    @Bindable public var logEntry: LogEntry

    var body: some View {
        Text(logEntry.note)
    }
}
