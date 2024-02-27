//
//  Settings.swift
//  Joex
//
//  Created by Samuel Pitoňák on 19/02/2024.
//

import Foundation

enum DeleteMigratedLogAfter: String, CaseIterable {
    case Immediately = "Migration"
    case OneDay = "1 day"
    case ThreeDays = "3 days"
    case OneWeek = "1 week"
    case TwoWeeks = "2 weeks"
    case OneMonth = "1 month"
}

enum AuthenticationTimeout: String, CaseIterable {
    case Immediately = "App close"
    case OneMinute = "1 minute"
    case FiveMinutes = "5 minutes"
    case FifteenMinutes = "15 minutes"
}
