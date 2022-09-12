//
//  SessionView+Observed.swift
//  AsyncSwift
//
//  Created by Kim Insub on 2022/09/12.
//

import SwiftUI

extension SessionView {
    final class Observed: ObservableObject {
        @Published var session = Session()
        let speakerImageSize: CGFloat = 80
    }
}
