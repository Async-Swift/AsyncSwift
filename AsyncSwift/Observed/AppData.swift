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
    var scannedSeminarQR = true // Universal Link로 진입시 QR코드 스캔 여부

    func checkLink(url: URL) -> Bool {
        guard let host = URLComponents(url: url, resolvingAgainstBaseURL: true)?.host else { return false }

        switch host {
        case Tab.stamp.rawValue:
            scannedSeminarQR = true
            currentTab = .stamp
        default:
            currentTab = .ticketing
        }
        return true
    }
}


enum Tab: String, CaseIterable {
    case event
    case ticketing
    case stamp

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
