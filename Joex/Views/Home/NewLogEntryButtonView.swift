//
//  NewLogEntryButtonView.swift
//  Joex
//
//  Created by Samuel Pitoňák on 06/02/2024.
//

import SwiftUI
import FirebaseAnalytics

struct NewLogEntryButtonView: View {
    @Binding public var newLogEntry: Bool
    @Binding public var newLogEntryNote: Bool
    
    func handleClick() {
//        newLogEntry = true
        newLogEntryNote = true
        Analytics.logEvent("new_log_entry_note", parameters: [:])
    }
    
    var body: some View {
        FabButtonView(handleClick: { self.handleClick() }, icon: "plus", color: Color.indigo)
            .padding([.bottom], -5)
//            .confirmationDialog("New log entry type", isPresented: $newLogEntry) {
//                Button("Note") { newLogEntryNote = true }
//                Button("Cancel", role: .cancel) { newLogEntry = false }
//            } message: {
//                Text("Select type of new log entry")
//            }
    }
}
