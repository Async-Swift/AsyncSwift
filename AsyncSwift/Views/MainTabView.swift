//
//  ContentView.swift
//  AsyncSwift
//
//  Created by Kim Insub on 2022/09/06.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            EventView()
                .tabItem {
                    Label("Event", systemImage: "calendar")
                }
            
            TicketingView()
                .tabItem {
                    Label("Ticketing", systemImage: "banknote")
                }
            StampView()
                .tabItem {
                    Label("Stamp", systemImage: "checkmark.square")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
