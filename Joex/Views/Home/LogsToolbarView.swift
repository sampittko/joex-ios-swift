//
//  LogsToolbarView.swift
//  Joex
//
//  Created by Samuel Pitoňák on 06/02/2024.
//

import SwiftUI

struct LogsToolbarView: ToolbarContent {
    public var isMigrationDisabled: Bool
    
    var body: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            NavigationLink(destination: SettingsView()) {
                Text("Settings")
            }
        }
        
        ToolbarItem(placement: .topBarTrailing) {
            NavigationLink(destination: MigrationView()) {
                Text("Migration")
            }
            .disabled(isMigrationDisabled)
        }
    }
}
