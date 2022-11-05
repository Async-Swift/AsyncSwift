//
//  StampView.swift
//  AsyncSwift
//
//  Created by Inho Choi on 2022/10/29.
//

import SwiftUI
import UIKit

struct StampView: View {
    @StateObject var observed = Observed()
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            ScrollViewReader { value in
                ZStack {
                    ForEach(0..<observed.cards.count, id: \.self) { index in
                        observed.cards[observed.events[index]]?.currentImage?
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .offset(y: calculateY(index: index))
                            .onTapGesture {
                                observed.didCardTapped(index: index)
                            }
                    }
                }
                .offset(y: UIScreen.main.bounds.height / 2)
            }
            Spacer(minLength: observed.isExpand ? UIScreen.main.bounds.height : 0)
        }
        .padding()
        .onOpenURL{ url in
            Task {
                await observed.openByLink(url: url)
            }
        }
    } // body
}

extension StampView {
    func calculateY(index : Int?) -> CGFloat {
        withAnimation(.spring()) {
            guard let index = index else { return .zero }
            var result: CGFloat
            if observed.cards[observed.events[index]]!.isSelected {
                result = .zero - UIScreen.main.bounds.height / 2
            } else {
                result = observed.cards[observed.events[index]]!.originalPosition
            }
            return result
        }
    }
}

struct StampView_Previews: PreviewProvider {
    static var previews: some View {
        StampView()
            .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro Max"))
        
        StampView()
            .previewDevice(PreviewDevice(rawValue: "iPhone SE (3rd generation)"))
    }
}


