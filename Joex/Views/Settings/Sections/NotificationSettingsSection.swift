struct NotificationSettingsSection: View {
    @Binding var dailyMigrationReminder: Bool
    @Binding var dailyMigrationReminderTimeState: Date
    @Binding var migrationLogsCountBadge: Bool
    var onReminderToggle: (Bool, Bool) -> Void
    var onTimeChange: (Date, Date) -> Void
    var onBadgeToggle: (Bool, Bool) -> Void
    
    var body: some View {
        Section("Notifications") {
            Toggle("Daily migration reminder", isOn: $dailyMigrationReminder)
                .onChange(of: dailyMigrationReminder, onReminderToggle)

            if dailyMigrationReminder {
                DatePicker("Migration reminder time", 
                          selection: $dailyMigrationReminderTimeState,
                          displayedComponents: .hourAndMinute)
                    .onChange(of: dailyMigrationReminderTimeState, onTimeChange)
            }
            
            Toggle("Waiting logs count badge", isOn: $migrationLogsCountBadge)
                .onChange(of: migrationLogsCountBadge, onBadgeToggle)
        }
    }
} 