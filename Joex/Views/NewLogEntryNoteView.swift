//
//  NewLogEntryNoteView.swift
//  Joex
//
//  Created by Samuel Pitoňák on 06/02/2024.
//

import SwiftUI

struct NewLogEntryNoteView: View {
    @Environment(\.modelContext) private var modelContext
    @Binding public var note: String;
    @Binding public var newLogEntry: Bool;
    @Binding public var newNote: Bool;
    
    var body: some View {
        NavigationView {
            VStack {
                TextEditor(text: $note)
                    .padding()
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        newLogEntry = false
                        newNote = false
                        note = ""
                    }, label: {
                        Text("Discard")
                    })
                    .accessibilityLabel("Discard note")
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        let logEntryNote = LogEntry(note: note)
                        modelContext.insert(logEntryNote)
                        newLogEntry = false
                        newNote = false
                        note = ""
                    }, label: {
                        Text("Save")
                    })
                    .disabled(note.isEmpty)
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.capsule)
                    .accessibilityLabel("Save note")
                }
            }
        }
    }
}
