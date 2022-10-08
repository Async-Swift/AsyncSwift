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
        @Published var stampImages = [String : [String: UIImage]]()
        var events: [String]? = nil
        private let keyChainManager = KeyChainManager()
        
        private let durationAndDelay: CGFloat = 0.3
        
        init() {
            fetchStampsImages()
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
        
        /// Storage에 저장되어 있는 Stamp Image를 가져오는 함수이다.
        /// - stampImages에 stampImages[이벤트 이름][front/back] 에 UIImage 형태로 저장된다.
        func fetchStampsImages(){
            let pwRaw = keyChainManager.getItem(key: keyChainManager.stampKey) as? String
            
            events = pwRaw?.toStringArray()
            
            guard let events = events else { return }
            
            
            for event in events.reversed() {
                self.stampImages[event] = .init()
                Task {
                    // MARK: 이미지 주소에 대해서 확실하지 않음으로 수정이 필요
                    guard let url = URL(string: "https://raw.githubusercontent.com/Async-Swift/jsonstorage/main/Images/Stamp/" + event + "Front.png") else { return }
                    let request = URLRequest(url: url)
                    let (data, response) = try await URLSession.shared.data(for: request)
                    
                    guard let httpResponse = response as? HTTPURLResponse,
                          httpResponse.statusCode == 200 else { return }
                    // Publisher를 수정하기 위한 DispatchQueue
                    DispatchQueue.main.async { [weak self] in
                        self?.stampImages[event]?["front"] = UIImage(data: data)
                    }
                }
                Task {
                    // MARK: 이미지 주소에 대해서 확실하지 않음으로 수정이 필요
                    guard let url = URL(string: "https://raw.githubusercontent.com/Async-Swift/jsonstorage/main/Images/Stamp/" + event + "Back.png") else { return }
                    let request = URLRequest(url: url)
                    let (data, response) = try await URLSession.shared.data(for: request)
                    
                    guard let httpResponse = response as? HTTPURLResponse,
                          httpResponse.statusCode == 200 else { return }
                    
                    DispatchQueue.main.async { [weak self] in
                        self?.stampImages[event]?["back"] = UIImage(data: data)
                    }
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
