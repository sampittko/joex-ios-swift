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
    @Environment(\.colorScheme) var colorScheme
    @State private var editing: Bool = false
    @State private var updatedNote = ""

    var body: some View {
        Button {
            editing = true
            updatedNote = logEntry.note
        } label: {
            Text(logEntry.note)
                .lineLimit(1)
        }
        .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
        .sheet(isPresented: $editing, onDismiss: {
            editing = false
        }, content: {
            NavigationView {
                VStack {
                    TextEditor(text: $updatedNote)
                        .padding()
                }
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button(action: {
                            editing = false
                            updatedNote = logEntry.note
                        }, label: {
                            Text("Close")
                        })
                        .accessibilityLabel("Close note")
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                            logEntry.note = updatedNote
                            editing = false
                        }, label: {
                            Text("Update")
                        })
                        .disabled(updatedNote.isEmpty || updatedNote == logEntry.note)
                        .buttonStyle(.borderedProminent)
                        .buttonBorderShape(.capsule)
                        .accessibilityLabel("Update note")
                    }
                }
            }
        })
    }
}
