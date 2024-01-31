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
    @Query private var logEntries: [LogEntry]
    @State private var newNote: Bool = false
    @State private var newVoiceMemo: Bool = false
    @State private var newLogEntry: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                GeometryReader { geometry in
                    ScrollView {
                        if logEntries.isEmpty {
                            VStack {
                                Text("No logs to migrate 🎉")
                                    .frame(maxWidth: 400)
                            }
                            .padding([.top], -50)
                            .frame(width: geometry.size.width)
                            .frame(minHeight: geometry.size.height)
                        } else {
                            List {
                                ForEach(logEntries) { logEntry in
                                    LogEntryView(logEntry: logEntry)
                                }
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
                    Button("Voice memo") { newVoiceMemo = true }
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
                    .disabled(logEntries.count == 0)
                    .accessibilityLabel("Migrate logs")
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: LogEntry.self)
}
