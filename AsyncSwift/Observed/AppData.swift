//
//  AppData.swift
//  AsyncSwift
//
//  Created by Inho Choi on 2022/09/08.
//

import SwiftUI
import UIKit

final class AppData: ObservableObject {
    @Published var currentTab: Tab = .event // Universal Link로 앱진입시 StampView 전환을 위한 변수

    func checkLink(url: URL) -> Bool {
        // URL Example = https://www.asyncswift.info?seminar=seminar002&tab=ticketing
        // URL Example = https://www.asyncswift.info?seminar=seminar002&tab=event
        guard let host = URLComponents(url: url, resolvingAgainstBaseURL: true)?.host else { return false }

        var queries: [String: String] = [:]
        for item in URLComponents(url: url, resolvingAgainstBaseURL: true)?.queryItems ?? [] {
            queries[item.name] = item.value
        }
        
        //TODO: seminar002도 나중에 JSON으로 관리하면 앱 업데이트 할 필요 없이 간편하게 수정 할 수 있을것 같습니다.
        if queries["seminar"] != "seminar002" {
            return false
        }

        switch queries["tab"] {
        case Tab.stamp.rawValue:
            KeyChain.shared.addItem(key: queries["seminar"], pwd: "true") ? print("Adding Stamp History KeyChain is Success") : print("Adding Stamp History is Fail")
            currentTab = .stamp
        case Tab.event.rawValue:
            currentTab = .event
        default:
            return false
        }

        return true
    }
}


enum Tab: String, CaseIterable {
     case event = "Event"
     case ticketing = "Ticketing"
     case stamp = "Stramp"

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
