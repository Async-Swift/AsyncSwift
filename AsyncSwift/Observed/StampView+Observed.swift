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
        @Published var stampImages = [String : [String: UIImage]]() // [ String : ( FrontUIImage, BackUIImage ) ]
        var events: [String]? = nil
        
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
            let pwRaw = KeyChain.shared.getItem(key: KeyChain.shared.stampKey) as? String
            
            events = pwRaw?.toStringArray()
            
            guard let events = events else { return }

            
            for event in events {
                self.stampImages[event] = [String: UIImage]()
                // MARK: 이미지 주소에 대해서 확실하지 않음으로 수정이 필요
                guard let url = URL(string: "https://raw.githubusercontent.com/Async-Swift/jsonstorage/stamp/stampimage/" + event + "Front.png") else { return }
                
                var request = URLRequest(url: url)
                var dataTask = URLSession.shared.dataTask(with: request) { data, response, _ in
                    guard
                        let response = response as? HTTPURLResponse,
                        response.statusCode == 200,
                        let data = data
                    else { return }
                    
                    DispatchQueue.main.async { [weak self] in
                        let frontImage = UIImage(data: data)
                        self?.stampImages[event]?["front"] = frontImage
                    }
                }
                dataTask.resume()
                
                guard let url = URL(string: "https://raw.githubusercontent.com/Async-Swift/jsonstorage/stamp/stampimage/" + event + "Back.png") else { return }
                
                request = URLRequest(url: url)
                dataTask = URLSession.shared.dataTask(with: request) { data, response, _ in
                    guard
                        let response = response as? HTTPURLResponse,
                        response.statusCode == 200,
                        let data = data
                    else { return }
                    
                    DispatchQueue.main.async { [weak self] in
                        let backImage = UIImage(data: data)
                        self?.stampImages[event]?["back"] = backImage
                    }
                }
                dataTask.resume()
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
