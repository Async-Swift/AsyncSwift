//
//  AsyncSwiftApp+Observed.swift
//  AsyncSwift
//
//  Created by Inho Choi on 2022/09/08.
//

import SwiftUI

class AppData: ObservableObject {
	@Published var currentTab: Tab = .event
}


enum Tab: String, CaseIterable {
	case event = "event"
	case tickekting = "ticketing"
	case stamp = "stamp"
}
