//
//  ContentView.swift
//  Joex
//
//  Created by Samuel Pitoňák on 28/01/2024.
//

import SwiftUI
import SwiftData

struct VerticalLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack {
            configuration.icon.font(.headline)
            configuration.title.font(.footnote)
        }
    }
}

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \LogEntry.created, order: .reverse) private var logEntries: [LogEntry]
    @State private var newNote: Bool = false
    @State private var newLogEntry: Bool = false
    @State private var note: String = "Enter your notes here"
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                List {
                    ForEach(logEntries) {logEntry in
                        LogEntryView(logEntry: logEntry)
                    }
                }
                
                Button {
                    newLogEntry = true
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 25).weight(.semibold))
                        .padding(24)
                        .background(Color.indigo)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                        .shadow(radius: 4, x: 0, y: 4)
                }
                .padding([.bottom], -5)
                .confirmationDialog("Change background", isPresented: $newLogEntry) {
                    Button("Note") { newNote = true }
                    Button("Cancel", role: .cancel) { newLogEntry = false }
                } message: {
                    Text("Select type of new log entry")
                }
            }
            .navigationTitle("Logs")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        
                    }, label: {
                        Label("Migration", systemImage: "book.pages")
                            .labelStyle(VerticalLabelStyle())
                    })
                    .disabled(logEntries.isEmpty)
                    .accessibilityLabel("Migrate logs")
                }
            }
            .sheet(isPresented: $newNote, onDismiss: {
                newLogEntry = false
                newNote = false
            }, content: {
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
                                note = "Enter your notes here"
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
                                note = "Enter your notes here"
                            }, label: {
                                Text("Save")
                            })
                            .buttonStyle(.borderedProminent)
                            .buttonBorderShape(.capsule)
                            .accessibilityLabel("Save note")
                        }
                    }
                }
            })
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: LogEntry.self)
}
