//
//  SettingsView.swift
//  Joex
//
//  Created by Samuel Pitoňák on 17/02/2024.
//

import SwiftUI

enum DeleteMigratedLogAfter: String, CaseIterable {
    case Never = "Never"
    case OneDay = "1 day"
    case ThreeDays = "3 days"
    case OneWeek = "1 week"
    case OneMonth = "1 month"
}

struct SettingsView: View {
    @AppStorage("deleteMigratedLogAfter")
    private var deleteMigratedLogAfter: String = DeleteMigratedLogAfter.Never.rawValue
    
    var body: some View {
        Form {
            Picker("Delete isMigrated log after", selection: $deleteMigratedLogAfter) {
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
