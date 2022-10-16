//
//  Text+.swift
//  AsyncSwift
//
//  Created by Kim Insub on 2022/10/17.
//

import Foundation
import SwiftUI

extension Text {
    func profileInputTitle() -> some View {
        self.font(.footnote)
            .fontWeight(.bold)
            .frame(minHeight: 18)
    }
}
