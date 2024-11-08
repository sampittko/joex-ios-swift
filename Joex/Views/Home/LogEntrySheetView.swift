import SwiftUI
import FirebaseAnalytics

struct LogEntrySheetView: View {
    @Binding public var updatedNote: String
    @Binding public var editing: Bool
    public var logEntry: LogEntry
    @FocusState private var keyboardFocused: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                TextEditor(text: $updatedNote)
                    .padding()
                    .focused($keyboardFocused)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) { closeButton }
                ToolbarItem(placement: .topBarTrailing) { updateButton }
            }
        }
        .onAppear {
            keyboardFocused = true
            Analytics.logEvent("log_entry_view_appeared", parameters: [:])
        }
    }
    
    private var closeButton: some View {
        Button(action: handleClose) {
            Text("Close")
        }
        .accessibilityLabel("Close note")
    }
    
    private var updateButton: some View {
        Button(action: handleUpdate) {
            Text("Update")
        }
        .disabled(updatedNote.isEmpty || updatedNote == logEntry.note)
        .buttonStyle(.borderedProminent)
        .buttonBorderShape(.capsule)
        .accessibilityLabel("Update note")
    }
    
    private func handleClose() {
        editing = false
        updatedNote = logEntry.note
        Analytics.logEvent("log_entry_view_disappeared", parameters: ["log_entry_updated": false])
    }
    
    private func handleUpdate() {
        logEntry.note = updatedNote
        logEntry.updatedDate = .now
        editing = false
        Analytics.logEvent("log_entry_view_disappeared", parameters: ["log_entry_updated": true])
    }
} 