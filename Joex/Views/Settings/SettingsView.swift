import SwiftUI
import SwiftData
import UserNotifications
import StoreKit
import FirebaseAnalytics

struct SettingsView: View {
    // MARK: - Properties
    private let viewUuid = UUID().uuidString
    
    // MARK: - Environment
    @Environment(\.modelContext) private var modelContext
    @Environment(\.requestReview) private var requestReview
    
    // MARK: - Queries
    @Query(filter: #Predicate<LogEntry> { $0.isMigrated }) private var migratedLogEntries: [LogEntry]
    @Query(filter: #Predicate<LogEntry> { !$0.isMigrated }) private var logEntries: [LogEntry]
    
    // MARK: - App Storage
    @AppStorage("deleteMigratedLogAfter") private var deleteMigratedLogAfter = DeleteMigratedLogAfter.ThreeDays.rawValue
    @AppStorage("dailyMigrationReminder") private var dailyMigrationReminder = false
    @AppStorage("dailyMigrationReminderTime") private var dailyMigrationReminderTime = Date.now.timeIntervalSinceReferenceDate
    @AppStorage("migrationLogsCountBadge") private var migrationLogsCountBadge = false
    
    // MARK: - State
    @State private var dailyMigrationReminderTimeState = Date.now
    
    // MARK: - Body2
    var body: some View {
        Form {
            migrationSection
            notificationSection
            feedbackSection
        }
        .navigationTitle("Settings")
        .onAppear(perform: onAppearHandler)
        .onDisappear(perform: onDisappearHandler)
    }
}

// MARK: - Subviews and Handlers
private extension SettingsView {
    var migrationSection: some View {
        Section("Migration") {
            Picker("Delete log after", selection: $deleteMigratedLogAfter) {
                ForEach(DeleteMigratedLogAfter.allCases, id: \.self) { value in
                    Text(value.rawValue).tag(value.rawValue)
                }
            }
        }
    }
    
    var notificationSection: some View {
        Section("Notifications") {
            notificationToggles
        }
    }
    
    var notificationToggles: some View {
        Group {
            Toggle("Daily migration reminder", isOn: $dailyMigrationReminder)
                .onChange(of: dailyMigrationReminder, handleDailyReminderToggle)

            if dailyMigrationReminder {
                reminderTimePicker
            }
            
            Toggle("Waiting logs count badge", isOn: $migrationLogsCountBadge)
                .onChange(of: migrationLogsCountBadge, handleBadgeToggle)
        }
    }
    
    var reminderTimePicker: some View {
        DatePicker("Migration reminder time", 
                  selection: $dailyMigrationReminderTimeState,
                  displayedComponents: .hourAndMinute)
            .onChange(of: dailyMigrationReminderTimeState, handleReminderTimeChange)
            .transformEffect(.init(scaleX: 1, y: 1))
    }
    
    var feedbackSection: some View {
        Group {
            Button("Rate on App Store", action: rateAppStore)
            Button("Share feedback", action: shareFeedback)
        }
    }
}

// MARK: - Action Handlers
private extension SettingsView {
    func handleDailyReminderToggle(oldValue: Bool, isEnabled: Bool) {
        if isEnabled {
            setupNewReminder()
        } else {
            clearMigrationNotifications()
        }
    }
    
    func setupNewReminder() {
        dailyMigrationReminderTimeState = Date.now
        dailyMigrationReminderTime = dailyMigrationReminderTimeState.timeIntervalSinceReferenceDate
        requestNotificationAuthorization { granted in
            if !granted { dailyMigrationReminder = false }
        }
    }
    
    func handleReminderTimeChange(oldValue: Date, newDate: Date) {
        dailyMigrationReminderTime = newDate.timeIntervalSinceReferenceDate
        scheduleMigrationNotification(
            logEntriesCount: logEntries.count,
            notificationDate: newDate,
            dailyMigrationReminder: dailyMigrationReminder
        )
    }
    
    func handleBadgeToggle(oldValue: Bool, isEnabled: Bool) {
        requestNotificationAuthorization { granted in
            if granted {
                UNUserNotificationCenter.current().setBadgeCount(isEnabled ? logEntries.count : 0)
            } else {
                migrationLogsCountBadge = false
            }
        }
    }
    
    func rateAppStore() {
        Analytics.logEvent("rate_on_app_store_click", parameters: [:])
        requestReview()
    }
    
    func shareFeedback() {
        Analytics.logEvent("share_feedback_click", parameters: [:])
        if let url = URL(string: "mailto:\(CONTACT_EMAIL)?subject=\(CONTACT_SUBJECT)") {
            UIApplication.shared.open(url)
        }
    }
}

// MARK: - Lifecycle Handlers
private extension SettingsView {
    func onAppearHandler() {
        logSettingsViewEvent("settings_view_appeared")
        dailyMigrationReminderTimeState = Date(timeIntervalSinceReferenceDate: dailyMigrationReminderTime)
        UIDatePicker.appearance().minuteInterval = 15
    }
    
    func onDisappearHandler() {
        logSettingsViewEvent("settings_view_disappeared")
        migratedLogsAutoDelete(
            deleteMigratedLogAfter: deleteMigratedLogAfter,
            migratedLogEntries: migratedLogEntries,
            modelContext: modelContext
        )
    }
    
    func logSettingsViewEvent(_ eventName: String) {
        Analytics.logEvent(eventName, parameters: [
            "view_instance_uuid": viewUuid,
            "delete_migrated_log_after": deleteMigratedLogAfter,
            "daily_migration_reminder": dailyMigrationReminder,
            "daily_migration_reminder_time": dailyMigrationReminderTime,
            "migration_logs_count_badge": migrationLogsCountBadge
        ])
    }
}

// MARK: - Helper Functions
private extension SettingsView {
    func requestNotificationAuthorization(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, _ in
            completion(success)
        }
    }
}

#Preview {
    SettingsView()
}
