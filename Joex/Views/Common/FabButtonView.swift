//
//  FabButtonView.swift
//  Joex
//
//  Created by Samuel Pitoňák on 06/02/2024.
//

import SwiftUI

struct FabButtonView: View {
    @Environment(\.colorScheme) var colorScheme
    public var handleClick: () -> Void
    public var icon: String
    public var color: Color
    
    var body: some View {
        Button {
            handleClick()
        } label: {
            Image(systemName: icon)
                .font(.system(size: 25).weight(.semibold))
                .padding(24)
                .background(colorScheme == .dark ? .white : color)
                .foregroundColor(colorScheme == .dark ? color : .white)
                .clipShape(Circle())
                .shadow(radius: 4, x: 0, y: 4)
        }
    }
}
