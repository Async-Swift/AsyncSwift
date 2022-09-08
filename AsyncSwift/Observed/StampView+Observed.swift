//
//  StampView+Observed.swift
//  AsyncSwift
//
//  Created by Inho Choi on 2022/09/09.
//

import SwiftUI

extension StampView {
    final class Observed: ObservableObject {
        @Published var cardAnimatonModel = CardAnimationModel()
        
        let durationAndDelay: CGFloat = 0.3
        
        func didTabCard () {
            cardAnimatonModel.isTapped.toggle()
            
            if cardAnimatonModel.isTapped { // 카드 회전 연속을 위해서 if문 분리
                withAnimation(.linear(duration: durationAndDelay)) {
                    cardAnimatonModel.backDegree = 90
                }
                withAnimation(.linear(duration: durationAndDelay).delay(durationAndDelay)) {
                    cardAnimatonModel.frontDegree = 0
                }
            } else {
                withAnimation(.linear(duration: durationAndDelay)) {
                    cardAnimatonModel.frontDegree = -90
                }
                withAnimation(.linear(duration: durationAndDelay).delay(durationAndDelay)) {
                    cardAnimatonModel.backDegree = 0
                }
            }
        }
    }
    
    struct CardAnimationModel: Identifiable {
        let id = UUID()
        var backDegree: Double = 0.0
        var frontDegree: Double = -90.0
        var isTapped = false
    }
}
