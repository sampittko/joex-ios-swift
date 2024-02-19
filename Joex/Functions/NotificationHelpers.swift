//
//  scheduleMigrationNotification.swift
//  Joex
//
//  Created by Samuel Pitoňák on 19/02/2024.
//

import Foundation
import UserNotifications

func scheduleMigrationNotification(logEntriesCount: Int, notificationDate: Date) {
    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["migration"])
    
    let content = UNMutableNotificationContent()
    content.title = "Migration"
    content.body = logEntriesCount == 1 ? "One lonely log wants to go home" :  "Physical journal is hungry for your \(logEntriesCount) logs"
    content.sound = UNNotificationSound.default
    
    var date = DateComponents()
    date.hour = Calendar.current.component(.hour, from: notificationDate)
    date.minute = Calendar.current.component(.minute, from: notificationDate)
    let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)

    let request = UNNotificationRequest(identifier: "migration", content: content, trigger: trigger)
    
    UNUserNotificationCenter.current().add(request)
}
