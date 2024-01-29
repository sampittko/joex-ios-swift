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
    
    var body: some View {
        NavigationStack {
            ScrollView {
                ZStack(alignment: .bottom) {
                    List {
                        ForEach(logEntries) { logEntry in
                            LogEntryView(logEntry: logEntry)
                        }
                    }
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "plus")
                            .font(.title.weight(.semibold))
                            .padding()
                            .background(Color.purple)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                            .shadow(radius: 4, x: 0, y: 4)
                    }
                    .padding()
                }
            }
            .padding()
        }
    }
}
