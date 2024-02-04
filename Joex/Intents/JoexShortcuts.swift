//
//  JoexShortcuts.swift
//  Joex
//
//  Created by Samuel Pitoňák on 04/02/2024.
//

import AppIntents

struct JoexShortcuts: AppShortcutsProvider {
  static var appShortcuts: [AppShortcut] {
    AppShortcut(
        intent: AddLogEntryNoteIntent(),
        phrases: [
            "Add a note",
            "Add a \(.applicationName) note"
        ],
        shortTitle: "Add a note",
        systemImageName: "book.pages"
    )
  }
}
