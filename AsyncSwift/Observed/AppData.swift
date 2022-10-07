//
//  AppData.swift
//  AsyncSwift
//
//  Created by Inho Choi on 2022/09/08.
//

import SwiftUI
import UIKit

final class AppData: ObservableObject {
    /// Universal Link로 앱진입시 StampView 전환을 위한 변수
    @Published var currentTab: Tab = .event

    func checkLink(url: URL) async -> Bool {
        // URL Example = https://asyncswift.info?tab=Stamp&event=seminar002
        // URL Example = https://asyncswift.info?tab=Event
        
        // MARK: 버전 1의 오류를 바로잡습니다. @Toby
        Task {
            if self.fixKeyChain() {
                print("Remove KeyChain: seminar002")
            }
        }
        
        guard URLComponents(url: url, resolvingAgainstBaseURL: true)?.host != nil else { return false }
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
            return false
        }
        
        switch queries["tab"] {
        case Tab.stamp.rawValue:
            currentTab = .stamp
            guard let queryEvent = queries["event"] else { return false }
            if currentEventTitle == queryEvent {
                
                let pwRaw = KeyChain.shared.getItem(key: KeyChain.shared.stampKey) as? String

                let pw = pwRaw?.toStringArray()
                
                guard var pw = pw else { return false }

                pw.append(queryEvent)
                
                if KeyChain.shared.addItem(key: KeyChain.shared.stampKey, pwd: pw) {
                    return true
                } else {
                    return false
                }
            }
            
        case Tab.event.rawValue:
            currentTab = .event
        default:
            return false
        }

        return true
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
    private func fixKeyChain() -> Bool {
        return KeyChain.shared.deleteItem(key: "seminar002")
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
