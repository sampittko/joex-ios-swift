//
//  SettingsView.swift
//  Joex
//
//  Created by Samuel Pitoňák on 17/02/2024.
//

import SwiftUI

enum DeleteMigratedLogAfter: String, CaseIterable {
    case midnight  = "Midnight"
    case threeDays = "3 days"
    case oneWeek  = "1 week"
    case oneMonth  = "1 month"
}

struct SettingsView: View {
    @AppStorage("deleteMigratedLogAfter")
    private var deleteMigratedLogAfter: String = DeleteMigratedLogAfter.threeDays.rawValue
    
    var body: some View {
        Form {
            Picker("Delete migrated log after", selection: $deleteMigratedLogAfter) {
                ForEach(DeleteMigratedLogAfter.allCases, id: \.self) { value in
                    Text(value.rawValue).tag(value.rawValue)
                }
            }
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    SettingsView()
}
