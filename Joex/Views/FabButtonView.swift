//
//  FabButtonView.swift
//  Joex
//
//  Created by Samuel Pitoňák on 06/02/2024.
//

import SwiftUI

struct FabButtonView: View {
    public var handleClick: () -> Void
    public var icon: String
    
    var body: some View {
        Button {
            handleClick()
        } label: {
            Image(systemName: icon)
                .font(.system(size: 25).weight(.semibold))
                .padding(24)
                .background(Color.indigo)
                .foregroundColor(.white)
                .clipShape(Circle())
                .shadow(radius: 4, x: 0, y: 4)
        }
    }
}
