//
//  MigrationView.swift
//  Joex
//
//  Created by Samuel Pitoňák on 05/02/2024.
//

import SwiftUI

struct MigrationView: View {
    @Environment(\.dismiss) var dismiss
    public var logEntries: [LogEntry]
    
    func handleClick() {
        logEntries.last?.migrated = true
    }
    
    var body: some View {
        if logEntries.last != nil {
            VStack {
                HStack {
                    Text(logEntries.last?.note ?? "")
                        .padding()
                    
                    Spacer()
                }
                
                Spacer()
                
                HStack {
                    Spacer()
                    
                    FabButtonView(handleClick: self.handleClick, icon: "checkmark", color: Color.green)
                        .padding([.bottom], -5)
                        .padding([.trailing], 20)
                }
            }
            .navigationTitle("Migration")
            .onDisappear {
                dismiss()
            }
        }
    }
}
