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
    var unexpandedImage: Image?
    var expandedImage: Image?
    var originalPosition: CGFloat
    var eventTitle: String
    var isSelected = false
    var currentImage: Image?
}
