//
//  MigrationView.swift
//  Joex
//
//  Created by Samuel Pitoňák on 05/02/2024.
//

import SwiftUI

struct MigrationView: View {
    public var logEntries: [LogEntry]
    
    var body: some View {
        if logEntries.isEmpty {
            Text("Everything migrated 🎉").font(.title)
        } else {
            VStack {
                Text(logEntries.first?.note ?? "")
                Spacer()
                Button("Migrate log entry \(logEntries.first?.id ?? "")") {
                    logEntries.first?.migrated = true
                }
            }
        }
    }
}
