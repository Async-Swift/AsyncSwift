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
    var image: Image?
    var imageExtend: Image?
    var originalPosition: CGFloat
    var eventTitle: String
    var isSelected = false
    var currentImage: Image?
}
