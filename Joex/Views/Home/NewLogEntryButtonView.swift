import SwiftUI
import FirebaseAnalytics

struct NewLogEntryButtonView: View {
    private static let BOTTOM_PADDING: CGFloat = -5
    
    @Binding var newLogEntry: Bool
    @Binding var newLogEntryNote: Bool
    
    func handleClick() {
        newLogEntryNote = true
        Analytics.logEvent("new_log_entry_note", parameters: [:])
    }
    
    var body: some View {
        FabButtonView(handleClick: handleClick, icon: "plus", color: .indigo)
            .padding(.bottom, Self.BOTTOM_PADDING)
    }
}
