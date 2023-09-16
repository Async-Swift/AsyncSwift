//
//  StampView+Observed.swift
//  AsyncSwift
//
//  Created by Inho Choi on 2022/09/09.
//

import SwiftUI

extension StampView {
    @MainActor final class Observed: ObservableObject {
        @Published var cards: [Card] = []
        @Published var events = [String]()
        @Published var currentIndex = 0
        @Published var isLoading = true
        private let keyChainManager = KeyChainManager()
        private let cardInterval: CGFloat = (UIScreen.main.bounds.width - 32) * 56 / 358
        private let cardSize: CGFloat = UIScreen.main.bounds.width - 32
        
        init() {
            fetchStampsImages()
        }
        
        private func getEvents() -> [String] {
            let pwRaw = keyChainManager.getItem(key: keyChainManager.stampKey) as? String
            guard let convertedStringArray = pwRaw?.convertToStringArray() else { return [] }
            self.events = convertedStringArray.reversed()
            return events
        }
        
        /// Storage에 저장되어 있는 Stamp Image를 가져오는 함수이다.
        /// - 
        private func fetchStampsImages(){
            let events = getEvents()
            
            guard !events.isEmpty else {
                isLoading = false
                return
            }

            events.enumerated().forEach { [weak self] in
                guard let self else { return }
                let event = $0.element
                let index = $0.offset
                Task { @MainActor () -> Void in
                    guard let cardImageURL = URL(string: "https://raw.githubusercontent.com/Async-Swift/jsonstorage/main/Images/Stamp/" + event + "/stamp.png")
                    else { return }

                    let cardImageRequest = URLRequest(url: cardImageURL)
                    let (cardImageData, cardImageResponse) = try await URLSession.shared.data(for: cardImageRequest)
                    guard let httpsResponse = cardImageResponse as? HTTPURLResponse, httpsResponse.statusCode == 200 else { return }

                    guard let cardUIImage = UIImage(data: cardImageData) else { return }

                    let card = Card(
                        originalPosition: self.cardInterval * CGFloat(index),
                        image: Image(uiImage: cardUIImage),
                        event: event
                    )
                    self.cards.append(card)
                    if index == events.count - 1 {
                        self.isLoading = false
                    }
                }
            }
        }
                
        func isAvailableURL(url: URL) async -> Bool {
            // URL Example = https://asyncswift.info?tab=Stamp&event=Conference001
            // URL Example = https://asyncswift.info?tab=Event
            
            if URLComponents(url: url, resolvingAgainstBaseURL: true)?.host == nil { return false }
            var queries = [String: String]()
            for item in URLComponents(url: url, resolvingAgainstBaseURL: true)?.queryItems ?? [] {
                queries[item.name] = item.value
            }
            
            do {
                let stamp = try await fetchCurrentStamp()
                
                if queries["tab"] == Tab.stamp.rawValue {
                    guard let queryEvent = queries["event"] else { return false }
                    if stamp.title == queryEvent {
                        let pwRaw = keyChainManager.getItem(key: keyChainManager.stampKey) as? String
                        var pw: [String] = pwRaw?.convertToStringArray() ?? []
                        pw.append(queryEvent)
                        
                        if keyChainManager.addItem(key: keyChainManager.stampKey, pwd: pw.description) {
                            fetchStampsImages()
                        }
                    }
                }
            } catch {
                print(error.localizedDescription)
                return false
            }
            return true
        }
        
        private func fetchCurrentStamp() async throws -> Stamp {
            guard let url = URL(string: "https://raw.githubusercontent.com/Async-Swift/jsonstorage/main/currentEvent.json") // MARK: URL 주소 확인 테스트용으로 되어 있음
            else { return .init(title: "error") }
            
            let request = URLRequest(url: url)
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else { return .init(title: "error")}
            
            let stamp = try JSONDecoder().decode(Stamp.self, from: data)
            
            return stamp
        }
    }
}
