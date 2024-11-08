import SwiftUI

struct LogsToolbarView: ToolbarContent {
    private static let SETTINGS_TITLE = "Settings"
    private static let MIGRATION_TITLE = "Migration"
    
    var isMigrationDisabled: Bool
    
    private var settingsLink: some View {
        NavigationLink(destination: SettingsView()) {
            Text(Self.SETTINGS_TITLE)
        }
    }
    
    private var migrationLink: some View {
        NavigationLink(destination: MigrationView()) {
            Text(Self.MIGRATION_TITLE)
        }
        .disabled(isMigrationDisabled)
    }
    
    var body: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            settingsLink
        }
        
        ToolbarItem(placement: .topBarTrailing) {
            migrationLink
        }
    }
}
