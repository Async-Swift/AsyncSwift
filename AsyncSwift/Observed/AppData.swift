//
//  AppData.swift
//  AsyncSwift
//
//  Created by Inho Choi on 2022/09/08.
//

import UIKit

final class AppData: ObservableObject {
	@Published var currentTab: Tab = .event
	
}


enum Tab: String {
	case event
	case ticketing
	case stamp
}

