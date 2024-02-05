//
//  ContentView.swift
//  Joex
//
//  Created by Samuel Pitoňák on 28/01/2024.
//

import LocalAuthentication
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
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.modelContext) private var modelContext
    @Query(filter: #Predicate<LogEntry> { logEntry in
        logEntry.migrated == false
    }, sort: \LogEntry.created, order: .reverse) private var logEntries: [LogEntry]
    @State private var newNote: Bool = false
    @State private var newLogEntry: Bool = false
    @State private var note: String = ""
    @State private var isUnlocked = true
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "A way to protect log entries you enter into the application."
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                // authentication has now completed
                if success {
                    isUnlocked = true
                } else {
                    // there was a problem
                }
            }
        } else {
            // no biometrics
        }
    }
    
    var body: some View {
        VStack {
            if isUnlocked {
                NavigationStack {
                    ZStack(alignment: .bottom) {
                        List {
                            ForEach(logEntries) { logEntry in
                                LogEntryView(logEntry: logEntry)
                                    .swipeActions(allowsFullSwipe: false) {
                                        Button("Delete", systemImage: "trash", role: .destructive) {
                                            modelContext.delete(logEntry)
                                        }
                                    }
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
                            NavigationLink(destination: MigrationView(logEntries: logEntries)) {
                                Image(systemName: "book.pages")
                                    .accessibilityLabel("Migrate logs")
                                    .disabled(logEntries.isEmpty)
                            }
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
                    })
                }
            }
        }
        .onChange(of: scenePhase, initial: true) { oldPhase, newPhase in
            if newPhase == .inactive {
                isUnlocked = false
            } else if newPhase == .background {
                isUnlocked = false
            } else if newPhase == .active && isUnlocked == false {
                authenticate()
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: LogEntry.self)
}
