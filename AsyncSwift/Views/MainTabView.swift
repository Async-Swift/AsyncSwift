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
            EventView()
                .tabItem {
                    Label("Event", systemImage: "calendar")
                }
				.tag(Tab.event)
            
            TicketingView()
                .tabItem {
                    Label("Ticketing", systemImage: "banknote")
                }
				.tag(Tab.ticketing)
			
            StampView()
                .tabItem {
                    Label("Stamp", systemImage: "checkmark.square")
                }
				.tag(Tab.stamp)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
