//
//  AppData.swift
//  AsyncSwift
//
//  Created by Inho Choi on 2022/09/08.
//

import Foundation

class AppData: ObservableObject {
	@Published var currentTab: Tab = .event
}


enum Tab: String {
	case event = "event"
	case ticketing = "ticketing"
	case stamp = "stamp"
}
