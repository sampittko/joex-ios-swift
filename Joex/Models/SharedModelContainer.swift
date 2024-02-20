//
//  SharedModelContainer.swift
//  Joex
//
//  Created by Samuel Pitoňák on 20/02/2024.
//

import Foundation
import SwiftData

class SharedModelContainer {
    static var instance: ModelContainer = {
        let schema = Schema([
            LogEntry.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
}
