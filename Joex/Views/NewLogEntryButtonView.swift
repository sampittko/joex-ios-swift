//
//  NewLogEntryButtonView.swift
//  Joex
//
//  Created by Samuel Pitoňák on 06/02/2024.
//

import SwiftUI

struct NewLogEntryButtonView: View {
    @Binding public var newLogEntry: Bool
    @Binding public var newNote: Bool
    
    var body: some View {
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
}
