//
//  AsyncSwiftWidgetEntryView.swift
//  AsyncSwift
//
//  Created by 김인섭 on 2023/10/01.
//

import SwiftUI
import WidgetKit
import SVGKit

struct AsyncSwiftWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        if let imageData = entry.imageData, let image = SVGKImage(data: imageData) {
            Image(uiImage: image.uiImage)
                .resizable()
                .scaledToFill()
                .offset(y: 10)
        } else {
            Text("다음 행사때 만나요. 🤗")
        }
    }
}
