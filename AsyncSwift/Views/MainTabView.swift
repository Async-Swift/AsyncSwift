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

            ForEach(Tab.allCases, id: \.self) { it in
                if it == .event {
                    EventView()
                        .tabItem {
                            Label("Event", systemImage: "calendar")
                        }
                } else if it == .tickekting {
                    TicketingView()
                        .tabItem {
                            Label("Ticketing", systemImage: "banknote")
                        }
                } else {
                    StampView()
                        .tabItem {
                            Label("Stamp", systemImage: "checkmark.square")
                        }
                }
            }
        }
    }
}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainTabView()
//    }
//}
