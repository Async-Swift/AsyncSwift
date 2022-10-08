//
//  AppData.swift
//  AsyncSwift
//
//  Created by Inho Choi on 2022/09/08.
//

import SwiftUI
import UIKit

extension MainTabView {
    final class Observed: ObservableObject {
        /// Universal Link로 앱진입시 StampView 전환을 위한 변수
        @Published var currentTab: Tab = .event
        private let keyChainManager = KeyChainManager()

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
                    
                    let pwRaw = keyChainManager.keyChain.getItem(key: keyChainManager.stampKey) as? String
                    
                    
                    var pw: [String] = pwRaw?.toStringArray() ?? .init()
                    pw.append(queryEvent)
                    
                    if keyChainManager.keyChain.addItem(key: keyChainManager.stampKey, pwd: pw.description) {
                        DispatchQueue.main.async { [weak self] in
                            self?.currentTab = .stamp
                        }
                        return
                    } else {
                        return
                    }
                }
            case Tab.event.rawValue:
                currentTab = .event
            default:
                return
            }
            return
        }
        
        private func fetchCurrentStamp() async throws -> Stamp {
            guard let url = URL(string: "https://raw.githubusercontent.com/Async-Swift/jsonstorage/main/stamp.json")
            else { return .init(title: "error") }
            
            let request = URLRequest(url: url)
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else { return .init(title: "error")}

            let stamp = try JSONDecoder().decode(Stamp.self, from: data)
            
            return stamp
        }
        
        // MARK: 버전 1의 실수를 바로 잡습니다. @Toby
        /// "seminar002"가 key로 들어가 있던 기존 코드를 삭제하는 함수입니다.
        /// - KeyChain에 저장되는 방식을 개선하고자 함수가 구현되었습니다.
        func fixKeyChain() {
            if keyChainManager.keyChain.deleteItem(key: "seminar002") {
                keyChainManager.keyChain.addItem(key: keyChainManager.stampKey, pwd: ["seminar002"].description)
            }
        }
    }
}

enum Tab: String, CaseIterable {
     case event = "Event"
     case ticketing = "Ticketing"
     case stamp = "Stamp"

    var title: String {
        rawValue
    }

    var systemImageName: String {
        switch self {
        case .event: return "calendar"
        case .ticketing: return "banknote"
        case .stamp: return "checkmark.square"
        }
    }

    @ViewBuilder
    var view: some View {
        switch self {
        case .event: EventView()
        case .ticketing: TicketingView()
        case .stamp: StampView()
        }
    }
}
