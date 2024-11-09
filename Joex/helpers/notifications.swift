import Foundation
import UserNotifications

final class NotificationsManager {
    // MARK: - Singleton
    static let shared = NotificationsManager()
    private init() {}
    
    // MARK: - Constants
    private enum NotificationIdentifier {
        static let migration = "migration"
    }
    
    // MARK: - Migration Notifications
    func clearMigrationNotifications() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [NotificationIdentifier.migration])
        center.removeDeliveredNotifications(withIdentifiers: [NotificationIdentifier.migration])
    }
    
    func scheduleMigrationNotification(logEntriesCount: Int, notificationDate: Date, dailyMigrationReminder: Bool) {
        clearMigrationNotifications()
        
        guard dailyMigrationReminder, logEntriesCount > 0 else { return }
        
        let content = UNMutableNotificationContent()
        content.title = NSLocalizedString("Migration", comment: "Notification title for migration reminder")
        content.body = logEntriesCount == 1 
            ? NSLocalizedString("One log is waiting", comment: "Notification body for single log")
            : String(format: NSLocalizedString("%d logs are waiting", comment: "Notification body for multiple logs"), logEntriesCount)
        content.sound = UNNotificationSound.default
        
        let calendar = Calendar.current
        var date = DateComponents()
        date.hour = calendar.component(.hour, from: notificationDate)
        date.minute = calendar.component(.minute, from: notificationDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
        
        let request = UNNotificationRequest(
            identifier: NotificationIdentifier.migration,
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { [weak self] error in
            if let error = error {
                self?.handleError(error)
            }
        }
    }
    
    // MARK: - Badge Management
    func updateWaitingLogsCountBadge(logEntriesCount: Int, migrationLogsCountBadge: Bool) {
        guard migrationLogsCountBadge else { return }
        
        requestAuthorization { [weak self] success in
            guard success else { return }
            UNUserNotificationCenter.current().setBadgeCount(logEntriesCount)
        }
    }
    
    // MARK: - Convenience Methods
    func handleNotificationUpdates(
        logEntriesCount: Int,
        notificationDate: Date,
        dailyMigrationReminder: Bool,
        migrationLogsCountBadge: Bool
    ) {
        scheduleMigrationNotification(
            logEntriesCount: logEntriesCount,
            notificationDate: notificationDate,
            dailyMigrationReminder: dailyMigrationReminder
        )
        updateWaitingLogsCountBadge(
            logEntriesCount: logEntriesCount,
            migrationLogsCountBadge: migrationLogsCountBadge
        )
    }
    
    // MARK: - Helper Methods
    private func requestAuthorization(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if let error {
                self.handleError(error)
                completion(false)
                return
            }
            completion(success)
        }
    }
    
    private func handleError(_ error: Error) {
        print("NotificationsManager error: \(error.localizedDescription)")
    }
}
