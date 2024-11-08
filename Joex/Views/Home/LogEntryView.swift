import SwiftUI
import SwiftData
import FirebaseAnalytics

struct LogEntryView: View {
    @Bindable public var logEntry: LogEntry
    @Environment(\.colorScheme) var colorScheme
    @State private var editing: Bool = false
    @State private var updatedNote = ""

    var body: some View {
        Button {
            handleEdit()
        } label: {
            Text(logEntry.note)
                .lineLimit(1)
        }
        .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
        .sheet(isPresented: $editing, onDismiss: handleDismiss) {
            LogEntrySheetView(updatedNote: $updatedNote, editing: $editing, logEntry: logEntry)
        }
    }
    
    private func handleEdit() {
        editing = true
        updatedNote = logEntry.note
    }
    
    private func handleDismiss() {
        editing = false
    }
}
