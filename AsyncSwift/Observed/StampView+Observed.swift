//
//  StampView+Observed.swift
//  AsyncSwift
//
//  Created by Inho Choi on 2022/09/09.
//

import SwiftUI

extension StampView {
    @MainActor final class Observed: ObservableObject {
        @Published var cards = [String: Card]()
        @Published var events = [String]()
        @Published var currentIndex = 0
        private let keyChainManager = KeyChainManager()
        private let cardInterval: CGFloat = (UIScreen.main.bounds.width - 32) * 56 / 358
        private let cardSize: CGFloat = UIScreen.main.bounds.width - 32
        
        init() {
            fetchStampsImages()
        }
        
        private func getEvents() -> [String] {
            let pwRaw = keyChainManager.getItem(key: keyChainManager.stampKey) as? String
            guard var convertedStringArray = pwRaw?.convertToStringArray() else { return [] }
            convertedStringArray.insert("Test", at: 0) // MARK: Test 실제에서는 Next storage 둘다 설정해야함
            self.events = convertedStringArray.reversed()
            return events
        }
        
        /// Storage에 저장되어 있는 Stamp Image를 가져오는 함수이다.
        /// - 
        private func fetchStampsImages(){
            let events = getEvents()
            
            events.enumerated().forEach { [weak self] in
                guard let self = self else { return }
                let event = $0.element
                let index = $0.offset
                Task { @MainActor () -> Void in
                    guard let cardImageURL = URL(string: "https://raw.githubusercontent.com/Async-Swift/jsonstorage/ver2Test/Images/Stamp/" + event + "/stamp.png")
                    else { return }
                    
                    let cardImageRequest = URLRequest(url: cardImageURL)
                    let (cardImageData, cardImageResponse) = try await URLSession.shared.data(for: cardImageRequest)
                    guard let httpsResponse = cardImageResponse as? HTTPURLResponse, httpsResponse.statusCode == 200 else { return }
                    
                    guard let cardUIImage = UIImage(data: cardImageData) else { return }
                    
                    self.cards[event] = Card(originalPosition: cardInterval * CGFloat(index),
                                             image: Image(uiImage: cardUIImage))
                    // 가장 최근의 EventCard가 선택된 상태로 지정하기
                    if index == 0 {
                        self.cards[event]?.isSelected = true
                    }
                } // Task
            } // forEach
        } // fetchStampsImages
                
        func openByLink(url: URL) async {
            // URL Example = https://asyncswift.info?tab=Stamp&event=Conference001
            // URL Example = https://asyncswift.info?tab=Event
            
            guard URLComponents(url: url, resolvingAgainstBaseURL: true)?.host != nil else { return }
            var queries = [String: String]()
            for item in URLComponents(url: url, resolvingAgainstBaseURL: true)?.queryItems ?? [] {
                queries[item.name] = item.value
            }
            
            do {
                let stamp = try await fetchCurrentStamp()
                
                if queries["tab"] == Tab.stamp.rawValue {
                    guard let queryEvent = queries["event"] else { return }
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
            } // do-catch
        }
        
        private func fetchCurrentStamp() async throws -> Stamp {
            guard let url = URL(string: "https://raw.githubusercontent.com/Async-Swift/jsonstorage/ver2Test/currentEvent.json") // MARK: URL 주소 확인 테스트용으로 되어 있음
            else { return .init(title: "error") }
            
            let request = URLRequest(url: url)
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else { return .init(title: "error")}
            
            let stamp = try JSONDecoder().decode(Stamp.self, from: data)
            
            return stamp
        }
        
        /// 가장 맨 위에 올라온 카드라면 아무것도 작동안하도록, 아니라면 가장 맨위로 올도록 하는 함수입니다.
        func didCardTapped(index: Int, scrollReader: ScrollViewProxy) {
            if index != currentIndex {
                scrollReader.scrollTo(0, anchor: .init(x: 0, y: 94))
                withAnimation(.spring()) {
                    cards[events[index]]?.isSelected = true
                    cards[events[currentIndex]]?.isSelected = false
                    currentIndex = index
                }
            }
        } // func didCardTapped
        
        /// 카드의 개수에 따라서 카드의 위치를 지정해주는 함수입니다.
        func getCardOffsetY(index: Int, size: CGSize) -> CGFloat {
            withAnimation(.spring()) {
                guard let card = cards[events[index]] else { return .zero}
                if card.isSelected {
                    return .zero
                } else if size.height - CGFloat(94) < cardSize + CGFloat(16) + cardInterval * CGFloat(cards.count - 1) {
                    return cardSize + CGFloat(16) + card.originalPosition
                } else {
                    return size.height - CGFloat(94) - cardInterval * CGFloat(cards.count - index) - CGFloat(16)
                }
            }
        }
        
        /// 스크롤을 원할하게 하기 위해서 Offset 으로 원래 크기 보다 밀려난 만큼 Spacer로 확보해줍니다.
        func getSpacerMinLength(size: CGSize) -> CGFloat {
            if size.height - CGFloat(94) < cardSize + CGFloat(16) + cardInterval * CGFloat(cards.count - 1) {
                return cardSize + CGFloat(16) + cardInterval * CGFloat(cards.count - 1) + cardSize
            } else {
                return size.height - CGFloat(94) - cardInterval
            }
        }
    } // Class
} // Extention 
