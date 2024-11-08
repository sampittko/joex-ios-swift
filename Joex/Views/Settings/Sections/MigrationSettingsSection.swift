import SwiftUI

struct MigrationSettingsSection: View {
    @Binding var deleteMigratedLogAfter: String
    
    var body: some View {
        Section("Migration") {
            Picker("Delete log after", selection: $deleteMigratedLogAfter) {
                ForEach(DeleteMigratedLogAfter.allCases, id: \.self) { value in
                    Text(value.rawValue).tag(value.rawValue)
                }
            }
        }
    }
} 