//
//  NewLogEntryButtonView.swift
//  Joex
//
//  Created by Samuel Pitoňák on 06/02/2024.
//

import SwiftUI

struct NewLogEntryButtonView: View {
    @Binding public var newLogEntry: Bool
    @Binding public var newLogEntryNote: Bool
    
    func handleClick() {
        newLogEntry = true
    }
    
    var body: some View {
        FabButtonView(handleClick: self.handleClick, icon: "plus")
            .padding([.bottom], -5)
            .confirmationDialog("Change background", isPresented: $newLogEntry) {
                Button("Note") { newLogEntryNote = true }
                Button("Cancel", role: .cancel) { newLogEntry = false }
            } message: {
                Text("Select type of new log entry")
            }
    }
}
