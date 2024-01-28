//
//  VoiceMemo.swift
//  Joex
//
//  Created by Samuel Pitoňák on 28/01/2024.
//

import Foundation
import SwiftData

@Model public class VoiceMemo: LogEntry {
    private var name : String
    private var date : Date
    private var url : URL

    init(url: URL) {
        self.name = ""
        self.date = .now
        self.url = url
    }
}
