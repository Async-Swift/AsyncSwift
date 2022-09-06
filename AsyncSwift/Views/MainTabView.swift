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
            ScheduleView()
                .tabItem {
                    Label("일정", systemImage: "quote.opening")
                }
            TicketView()
                .tabItem {
                    Label("티켓", systemImage: "envelope")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
