//
//  View+.swift
//  AsyncSwift
//
//  Created by Kim Insub on 2022/09/09.
//

import Foundation
import SwiftUI

extension View {
    @ViewBuilder
    var customDivider: some View {
        Rectangle()
            .fill(Color.dividerForeground)
            .frame(height: 3)
            .edgesIgnoringSafeArea(.horizontal)
    }
}
