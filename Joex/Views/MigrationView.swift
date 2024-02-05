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
            VStack {
                if logEntries.isEmpty {
                    Text("🎉").font(.largeTitle)
                } else {
                    HStack {
                        Text(logEntries.last?.note ?? "Empty note")
                            .padding()
                        Spacer()
                    }
                    
                    Spacer()
                    
                    Button {
                        logEntries.first?.migrated = true
                    } label: {
                        Image(systemName: "arrow.forward")
                            .font(.system(size: 25).weight(.semibold))
                            .padding(24)
                            .background(Color.indigo)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                            .shadow(radius: 4, x: 0, y: 4)
                    }
                    .padding([.bottom], -5)
                }
            }
        .navigationTitle("Migration")
    }
}
