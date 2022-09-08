//
//  ContentView.swift
//  AsyncSwift
//
//  Created by Kim Insub on 2022/09/06.
//

import SwiftUI

enum Tab: String, CaseIterable {
    case event = "event"
    case tickekting = "ticketing"
    case stamp = "stamp"
}

struct MainTabView: View {
    @State var currentTab: Tab = .event
    var body: some View {
        TabView(selection: $currentTab) {

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
