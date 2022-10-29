//
//  View+.swift
//  AsyncSwift
//
//  Created by Kim Insub on 2022/09/09.
//

import SwiftUI

extension View {
    @ViewBuilder
    var customDivider: some View {
        Rectangle()
            .fill(Color.dividerForeground)
            .frame(height: 3)
            .edgesIgnoringSafeArea(.horizontal)
    }

    func placeholder(
        when shouldShow: Bool,
        text: String,
        isTextField: Bool
    ) -> some View {
        ZStack(alignment: .leading) {
            if isTextField {
                Text(text)
                    .font(.subheadline)
                    .foregroundColor(.placeholderForeground)
                    .frame(height: 20)
                    .opacity(shouldShow ? 1 : 0)
            } else {
                Text(text)
                    .font(.subheadline)
                    .foregroundColor(.placeholderForeground)
                    .frame(height: 20)
                    .opacity(shouldShow ? 1 : 0)
                    .offset(x: 3, y: -8)
            }
            self
        }
    }
}
