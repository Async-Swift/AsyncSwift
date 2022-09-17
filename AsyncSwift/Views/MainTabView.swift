//
//  ContentView.swift
//  AsyncSwift
//
//  Created by Kim Insub on 2022/09/06.
//

import SwiftUI

struct MainTabView: View {
	@EnvironmentObject var appData: AppData
    var body: some View {
        TabView(selection: $appData.currentTab) {
            ForEach(Tab.allCases, id: \.self) { tab in
                tab.view.tabItem {
                    Image(systemName: tab.systemImageName)
                    Text(tab.title)
                }
            }
        }
    }
}
