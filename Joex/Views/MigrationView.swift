//
//  MigrationView.swift
//  Joex
//
//  Created by Samuel Pitoňák on 05/02/2024.
//

import SwiftUI

struct MigrationView: View {
    public var logEntries: [LogEntry]
    
    func handleClick() {
        logEntries.last?.migrated = true
    }
    
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
                    
                    HStack {
                        Spacer()
                        
                        FabButtonView(handleClick: self.handleClick, icon: "checkmark")
                            .padding([.bottom], -5)
                            .padding([.trailing], 20)
                    }
                }
            }
        .navigationTitle("Migration")
    }
}
