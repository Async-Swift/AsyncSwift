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
