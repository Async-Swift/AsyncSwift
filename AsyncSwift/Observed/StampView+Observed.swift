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
        @Published var StampImages = [String : (UIImage, UIImage)]() // [ String : ( FrontUIImage, BackUIImage ) ]
        private var events = [String]()
        
        private let durationAndDelay: CGFloat = 0.3
        
        init() {
            fetchStamp()
        }
        
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
        
        private func fetchStamp(){
            let pwEvents = KeyChain.shared.getItem(key: KeyChain.shared.stampKey) as? [String]
            
            guard events == pwEvents else { return }
            for event in events {
                Task {
                    // MARK: 이미지 주소에 대해서 확실하지 않음으로 수정이 필요
                    guard let url = URL(string: "ttps://raw.githubusercontent.com/Async-Swift/jsonstorage/stamp/stampimage/" + event + "Front.png") else { return }
                    
                    var request = URLRequest(url: url)
                    var (data, response) = try await URLSession.shared.data(for: request)
                    guard let httpResponse = response as? HTTPURLResponse,
                          httpResponse.statusCode == 200 else { return }
                    
                    guard let frontImage = UIImage(data: data) else { return }
                    
                    // MARK: 이미지 주소에 대해서 확실하지 않음으로 수정이 필요
                    guard let url = URL(string: "ttps://raw.githubusercontent.com/Async-Swift/jsonstorage/stamp/stampimage/" + event + "Back.png") else { return }
                    request = URLRequest(url: url)
                    
                    (data, response) = try await URLSession.shared.data(for: request)
                    guard let httpResponse = response as? HTTPURLResponse,
                          httpResponse.statusCode == 200 else { return }
                    
                    guard let backImage = UIImage(data: data) else { return }
                    
                    
                    StampImages[event] = (frontImage, backImage)
                }
            }
        }
    }
    
    struct CardAnimationModel: Identifiable {
        fileprivate init() {}
        
        let id = UUID()
        var backDegree: Double = 0.0
        var frontDegree: Double = -90.0
        var isTapped = false
    }
}


