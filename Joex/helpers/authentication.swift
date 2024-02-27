//
//  authentication.swift
//  Joex
//
//  Created by Samuel Pitoňák on 26/02/2024.
//

import Foundation

func shouldReauthenticate(lastAuthenticated: TimeInterval, requireAuthentication: Bool, authenticationTimeout: String) -> Bool {
    if (requireAuthentication == false) {
        return false
    }
    
    let lastAuthenticatedDate = Date(timeIntervalSinceReferenceDate: lastAuthenticated)
    
    var reauthenticate: Bool
    switch authenticationTimeout {
        case AuthenticationTimeout.Immediately.rawValue:
            reauthenticate = true
        case AuthenticationTimeout.OneMinute.rawValue:
            reauthenticate = lastAuthenticatedDate.distance(to: Date.now) / 60 >= 1
        case AuthenticationTimeout.FiveMinutes.rawValue:
            reauthenticate = lastAuthenticatedDate.distance(to: Date.now) / 300 >= 5
        case AuthenticationTimeout.FifteenMinutes.rawValue:
            reauthenticate = lastAuthenticatedDate.distance(to: Date.now) / 900 >= 15
        default:
            reauthenticate = true
    }
    
    return reauthenticate
}
