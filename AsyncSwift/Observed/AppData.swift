//
//  AppData.swift
//  AsyncSwift
//
//  Created by Inho Choi on 2022/09/08.
//

import SwiftUI
import UIKit

final class AppData: ObservableObject {
    /// Universal Link로 앱진입시 StampView 전환을 위한 변수
    @Published var currentTab: Tab = .event
    
    private var currentStamp: Stamp?
    var isStampExist: Bool {
        if currentStamp == nil {
            fetchCurrentStamp()
        }
        
        return KeyChain.shared.getItem(key: currentStamp?.title) != nil
    }
    
    init(){
        fetchCurrentStamp()
    }

    func checkLink(url: URL) -> Bool {
        // URL Example = https://asyncswift.info?tab=Stamp
        // URL Example = https://asyncswift.info?tab=Event
        guard URLComponents(url: url, resolvingAgainstBaseURL: true)?.host != nil else { return false }
        var queries = [String: String]()
        for item in URLComponents(url: url, resolvingAgainstBaseURL: true)?.queryItems ?? [] {
            queries[item.name] = item.value
        }
        
        guard let currentStampName = currentStamp?.title else { return false }

        switch queries["tab"] {
        case Tab.stamp.rawValue:
            KeyChain.shared.addItem(key: currentStampName, pwd: "true") ? print("Adding Stamp History KeyChain is Success") : print("Adding Stamp History is Fail")
            currentTab = .stamp
        case Tab.event.rawValue:
            currentTab = .event
        default:
            return false
        }

        return true
    }
    
    private func fetchCurrentStamp() {
        guard
            let url = URL(string: "https://raw.githubusercontent.com/Async-Swift/jsonstorage/main/stamp.json")
            else { return }


        let request = URLRequest(url: url)
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, _ in
            guard
                let response = response as? HTTPURLResponse,
                response.statusCode == 200,
                let data = data
                else { return }
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {return }
                do {
                    print(data)
                    let stamp = try JSONDecoder().decode(Stamp.self, from: data)
                    self.currentStamp = stamp
                } catch {
                    self.currentStamp = nil
                }
            }
        }
        dataTask.resume()
    }
}


enum Tab: String, CaseIterable {
     case event = "Event"
     case ticketing = "Ticketing"
     case stamp = "Stamp"

    var title: String {
        rawValue
    }

    var systemImageName: String {
        switch self {
        case .event: return "calendar"
        case .ticketing: return "banknote"
        case .stamp: return "checkmark.square"
        }
    }

    @ViewBuilder
    var view: some View {
        switch self {
        case .event: EventView()
        case .ticketing: TicketingView()
        case .stamp: StampView()
        }
    }
}
