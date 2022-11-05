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
        @Published var isExpand = false
        private let keyChainManager = KeyChainManager()
            
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
            
            events.enumerated().forEach {
                let event = $0.element
                let index = $0.offset
                Task { @MainActor () -> Void in
                    guard let cardImageURL = URL(string: "https://raw.githubusercontent.com/Async-Swift/jsonstorage/ver2Test/Images/Stamp/" + event + "/stamp.png"),
                          let cardImageExtendURL = URL(string: "https://raw.githubusercontent.com/Async-Swift/jsonstorage/ver2Test/Images/Stamp/" + event + "/stampex.png")
                    else { return }
                    let cardImageRequest = URLRequest(url: cardImageURL)
                    let cardImageExtendRequest = URLRequest(url: cardImageExtendURL)
                    
                    let (cardImageData, cardImageResponse) = try await URLSession.shared.data(for: cardImageRequest)
                    guard let httpsResponse = cardImageResponse as? HTTPURLResponse, httpsResponse.statusCode == 200 else { return }
                    
                    let (cardImageExtendData, cardImageExtendResponse) = try await URLSession.shared.data(for: cardImageExtendRequest)
                    guard let httpsResponse = cardImageExtendResponse as? HTTPURLResponse, httpsResponse.statusCode == 200 else { return }
                    
                    guard let cardUIImage = UIImage(data: cardImageData), let cardExtendUIImage = UIImage(data: cardImageExtendData) else { return }
                    
                    self.cards[event] = Card(unexpandedImage: Image(uiImage: cardUIImage),
                                             expandedImage: Image(uiImage: cardExtendUIImage),
                                             originalPosition: CGFloat(56 * (index + 1)),
                                             eventTitle: event,
                                             currentImage: Image(uiImage: cardUIImage))
                    
                    // 가장 최근의 EventCard가 선택된 상태로 지정하기
                    if index == 0 {
                        self.cards[event]?.isSelected = true
                    }
                } // Task
            } // forEach
        } // fetchStampsImages
                
        func openByLink(url: URL) async {
            // URL Example = https://asyncswift.info?tab=Stamp&event=seminar002
            // URL Example = https://asyncswift.info?tab=Event
            
            guard URLComponents(url: url, resolvingAgainstBaseURL: true)?.host != nil else { return }
            var queries = [String: String]()
            for item in URLComponents(url: url, resolvingAgainstBaseURL: true)?.queryItems ?? [] {
                queries[item.name] = item.value
            }
            
            do {
                let stamp = try await fetchCurrentStamp()
                let currentEventTitle = stamp.title
                
                if queries["tab"] == Tab.stamp.rawValue {
                    guard let queryEvent = queries["event"] else { return }
                    if currentEventTitle == queryEvent {
                        let pwRaw = keyChainManager.getItem(key: keyChainManager.stampKey) as? String
                        var pw: [String] = pwRaw?.convertToStringArray() ?? .init()
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
        
        func didCardTapped(index: Int) {
            if index == currentIndex {
                withAnimation(.spring()) {
                    if isExpand {
                        cards[events[index]]?.currentImage = cards[events[index]]?.unexpandedImage
                    } else {
                        cards[events[index]]?.currentImage = cards[events[index]]?.expandedImage
                    }
                    isExpand.toggle()
                }
            } else {
                withAnimation(.spring()) {
                    cards[events[index]]?.isSelected = true
                    cards[events[currentIndex]]?.isSelected = false
                    if isExpand {
                        cards[events[currentIndex]]?.currentImage = cards[events[currentIndex]]?.unexpandedImage
                        isExpand = false
                    }
                    currentIndex = index
                }
            }
        } // func didCardTapped
        
        func getCardOffsetY(index: Int) -> CGFloat {
            withAnimation(.spring()) {
                guard let isSelected = cards[events[index]]?.isSelected,
                      let card = cards[events[index]]
                else { return .zero}
                
                return isSelected ? .zero - UIScreen.main.bounds.height / 2 : card.originalPosition
            }
        } // func getCardOffsetY
    } // Class
} // Extention
