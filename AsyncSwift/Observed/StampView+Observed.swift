//
//  StampView+Observed.swift
//  AsyncSwift
//
//  Created by Inho Choi on 2022/09/09.
//

import SwiftUI

extension StampView {
    @MainActor final class Observed: ObservableObject {
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
            
            events = pwRaw?.convertToStringArray()
            
            guard let events = events else { return }
            
            
            for event in events.reversed() {
                self.stampImages[event] = .init()
                
                Task { @MainActor () -> Void in
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
                Task { @MainActor () -> Void in
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
        
        func openByLink(url: URL) async {
            // URL Example = https://asyncswift.info?tab=Stamp&event=seminar002
            // URL Example = https://asyncswift.info?tab=Event
            
            guard URLComponents(url: url, resolvingAgainstBaseURL: true)?.host != nil else { return }
            var queries = [String: String]()
            for item in URLComponents(url: url, resolvingAgainstBaseURL: true)?.queryItems ?? [] {
                queries[item.name] = item.value
            }
            
            let currentEventTitle: String
            do {
                let stamp = try await fetchCurrentStamp()
                currentEventTitle = stamp.title
            } catch {
                print(error.localizedDescription)
                return
            }
            
            switch queries["tab"] {
            case Tab.stamp.rawValue:
                guard let queryEvent = queries["event"] else { return }
                if currentEventTitle == queryEvent {
                    
                    let pwRaw = keyChainManager.getItem(key: keyChainManager.stampKey) as? String
                    
                    
                    var pw: [String] = pwRaw?.convertToStringArray() ?? .init()
                    pw.append(queryEvent)
                    
                    if keyChainManager.addItem(key: keyChainManager.stampKey, pwd: pw.description) {
                        fetchStampsImages()
                    }
                }
            default: break
            }
            return
        }
        
        private func fetchCurrentStamp() async throws -> Stamp {
            guard let url = URL(string: "https://raw.githubusercontent.com/Async-Swift/jsonstorage/main/currentEvent.json")
            else { return .init(title: "error") }
            
            let request = URLRequest(url: url)
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else { return .init(title: "error")}
            
            let stamp = try JSONDecoder().decode(Stamp.self, from: data)
            
            return stamp
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
