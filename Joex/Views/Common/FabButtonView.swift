import SwiftUI

struct FabButtonView: View {
    @Environment(\.colorScheme) var colorScheme
    public var handleClick: () -> Void
    public var icon: String
    public var color: Color
    
    private let iconSize: CGFloat = 25
    private let padding: CGFloat = 24
    private let shadowRadius: CGFloat = 4
    private let shadowOffset: CGFloat = 4
    
    var body: some View {
        Button(action: handleClick) {
            buttonLabel
        }
    }
    
    private var buttonLabel: some View {
        Image(systemName: icon)
            .font(.system(size: iconSize).weight(.semibold))
            .padding(padding)
            .background(backgroundColor)
            .foregroundColor(foregroundColor)
            .clipShape(Circle())
            .shadow(radius: shadowRadius, x: 0, y: shadowOffset)
    }
    
    private var backgroundColor: Color {
        colorScheme == .dark ? .white : color
    }
    
    private var foregroundColor: Color {
        colorScheme == .dark ? color : .white
    }
}
