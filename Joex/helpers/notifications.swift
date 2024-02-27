//
//  notifications.swift
//  Joex
//
//  Created by Samuel Pitoňák on 19/02/2024.
//

import Foundation
import UserNotifications

func clearMigrationNotifications() {
    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["migration"])
}

func scheduleMigrationNotification(logEntriesCount: Int, notificationDate: Date, dailyMigrationReminder: Bool) {
    clearMigrationNotifications()
    
    if (dailyMigrationReminder == false || logEntriesCount == 0) {
        return
    }
    
    let content = UNMutableNotificationContent()
    content.title = "Migration"
    content.body = logEntriesCount == 1 ? "One log is waiting" :  "\(logEntriesCount) logs are waiting"
    content.sound = UNNotificationSound.default
    
    var date = DateComponents()
    date.hour = Calendar.current.component(.hour, from: notificationDate)
    date.minute = Calendar.current.component(.minute, from: notificationDate)
    let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)

    let request = UNNotificationRequest(identifier: "migration", content: content, trigger: trigger)
    
    UNUserNotificationCenter.current().add(request)
}

func updateWaitingLogsCountBadge(logEntriesCount: Int, migrationLogsCountBadge: Bool) {
    if (migrationLogsCountBadge == false) {
        return
    }
    
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
        if success {
            UNUserNotificationCenter.current().setBadgeCount(logEntriesCount)
        }
    }
}

func handleNotificationUpdates(logEntriesCount: Int, notificationDate: Date, dailyMigrationReminder: Bool, migrationLogsCountBadge: Bool) {
    scheduleMigrationNotification(logEntriesCount: logEntriesCount, notificationDate: notificationDate, dailyMigrationReminder: dailyMigrationReminder)
    updateWaitingLogsCountBadge(logEntriesCount: logEntriesCount, migrationLogsCountBadge: migrationLogsCountBadge)
}
