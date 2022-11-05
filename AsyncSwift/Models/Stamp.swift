//
//  Stamp.swift
//  AsyncSwift
//
//  Created by Inho Choi on 2022/09/15.
//

import SwiftUI

struct Stamp: Decodable {
    let title: String
}

struct Card {
    init(unexpandedImage: Image?, expandedImage: Image?, originalPosition: CGFloat) {
        self.unexpandedImage = unexpandedImage
        self.expandedImage = expandedImage
        self.originalPosition = originalPosition
        self.currentImage = unexpandedImage
    }
    
    var unexpandedImage: Image?
    var expandedImage: Image?
    var originalPosition: CGFloat
    var isSelected = false
    var currentImage: Image?
}
