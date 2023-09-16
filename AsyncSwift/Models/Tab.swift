//
//  Tab.swift
//  AsyncSwift
//
//  Created by Inho Choi on 2022/10/08.
//

import SwiftUI

enum Tab: String, CaseIterable {
    case event = "Event"
    case ticketing = "Ticketing"
    case stamp = "Stamp"
    case profile = "Profile"

    var title: String {
        rawValue
    }

    var systemImageName: String {
        switch self {
        case .event: return "calendar"
        case .ticketing: return "banknote"
        case .stamp: return "checkmark.square"
        case .profile: return "person.circle.fill"
        }
    }

    @ViewBuilder
    var view: some View {
        switch self {
        case .event: EventView()
        case .ticketing: TicketingView()
        case .stamp: StampView()
        case .profile: ProfileView()
        }
    }
}
