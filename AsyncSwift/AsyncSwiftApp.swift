//
//  AsyncSwiftApp.swift
//  AsyncSwift
//
//  Created by Kim Insub on 2022/09/06.
//

import SwiftUI

@main
struct AsyncSwiftApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
	@ObservedObject var appData: AppData = AppData()

    var body: some Scene {
        WindowGroup {
            MainTabView()
				.environmentObject(appData)
                .onOpenURL { url in
                    if appData.checkLink(url: url) {
                        print("Success Link URL: \(url)")
                    } else {
                        print("Fail Link URL: \(url)")
                    }
                }
        }
    }
}
