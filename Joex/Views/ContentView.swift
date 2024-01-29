//
//  ContentView.swift
//  Joex
//
//  Created by Samuel Pitoňák on 28/01/2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Query private var logEntries: [LogEntry]
    @State private var newNote: Bool = false
    @State private var migration: Bool = false
    @State private var newVoiceMemo: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                ScrollView {
                    List {
                        ForEach(logEntries) { logEntry in
                            LogEntryView(logEntry: logEntry)
                        }
                    }
                }
                
                HStack {
                    Button {
                        if newNote {
                            newNote = false
                        } else {
                            newNote = true
                        }
                    } label: {
                        Image(systemName: "note.text")
                            .font(.system(size: 20).weight(.semibold))
                            .padding(25)
                            .background(Color.gray)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                            .shadow(radius: 4, x: 0, y: 4)
                    }
                    .padding([.trailing], 5)
                    
                    Button {
                        if migration {
                            migration = false
                        } else {
                            migration = true
                        }
                    } label: {
                        Image(systemName: "book.pages")
                            .font(.system(size: 20).weight(.black))
                            .padding(24)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                            .shadow(radius: 4, x: 0, y: 4)
                    }
                    .padding([.leading, .trailing], 5)
                    
                    Button {
                        if newVoiceMemo {
                            newVoiceMemo = false
                        } else {
                            newVoiceMemo = true
                        }
                    } label: {
                        Image(systemName: "waveform")
                            .font(.system(size: 20).weight(.black))
                            .padding(24)
                            .background(Color.gray)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                            .shadow(radius: 4, x: 0, y: 4)
                    }
                    .padding([.leading], 5)
                }
            }
            .overlay {
                if newNote {
                    Text("Text editor")
                }
                
                if migration {
                    Text("Migration")
                }
                
                if newVoiceMemo {
                    Text("Recording")
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: LogEntry.self)
}
