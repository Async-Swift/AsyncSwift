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
    var originalPosition: CGFloat
    var isSelected = false
    var image: Image
}
