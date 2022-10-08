//
//  ContentView.swift
//  AsyncSwift
//
//  Created by Kim Insub on 2022/09/06.
//

import SwiftUI

struct MainTabView: View {
    @StateObject var observed = Observed()
    
    var body: some View {
        TabView(selection: $observed.currentTab) {
            ForEach(Tab.allCases, id: \.self) { tab in
                tab.view.tabItem {
                    Image(systemName: tab.systemImageName)
                    Text(tab.title)
                }
            }
        }
        .onOpenURL { url in
            Task {
                if await observed.checkLink(url: url) {
                    print("Success Link URL: \(url)")
                } else {
                    print("Fail Link URL: \(url)")
                }
            }
        }
        .onAppear {
            observed.fixKeyChain()
        }
    }
}
