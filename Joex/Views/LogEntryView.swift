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
            SheetView(updatedNote: $updatedNote, editing: $editing, logEntry: logEntry)
        })
    }
}

struct SheetView: View {
    @Binding public var updatedNote: String
    @Binding public var editing: Bool
    public var logEntry: LogEntry
    @FocusState private var keyboardFocused: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                TextEditor(text: $updatedNote)
                    .padding()
                    .focused($keyboardFocused)
                    .overlay {
                        if updatedNote.isEmpty {
                            Text("<- start typing")
                                .padding()
                                .position(x: 85, y: 33)
                                .opacity(0.25)
                        }
                    }
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
                        logEntry.updatedDate = .now
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
        .onAppear {
            keyboardFocused = true
        }
    }
}
