//
//  NewLogEntryNoteView.swift
//  Joex
//
//  Created by Samuel Pitoňák on 06/02/2024.
//

import SwiftUI

var INITIAL_NOTE: String = ""

struct NewLogEntryNoteView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var note: String = INITIAL_NOTE;
    public var onDiscard: () -> Void
    public var onSave: () -> Void
    @FocusState private var keyboardFocused: Bool
    
    func createNoteLogEntry() {
        let logEntryNote = LogEntry(note: note)
        modelContext.insert(logEntryNote)
    }
    
    func handleSave() {
        createNoteLogEntry()
        resetNote()
        onSave()
    }
    
    func handleDiscard() {
        resetNote()
        onDiscard()
    }
    
    func resetNote() {
        note = INITIAL_NOTE
    }
    
    var body: some View {
        NavigationView {
            VStack {
                TextEditor(text: $note)
                    .padding()
                    .focused($keyboardFocused)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        handleDiscard()
                    }, label: {
                        Text("Discard")
                    })
                    .accessibilityLabel("Discard note")
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        handleSave()
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
        .onAppear {
            keyboardFocused = true
        }
    }
}
