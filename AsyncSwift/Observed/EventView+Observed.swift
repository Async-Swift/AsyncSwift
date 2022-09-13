//
//  EventView+Observed.swift
//  AsyncSwift
//
//  Created by Kim Insub on 2022/09/08.
//

import Foundation
import SwiftUI

extension EventView {
    final class Observed: ObservableObject {

        @Published var response = JSONResponse()
        @Published var eventStatus: EventStatus = .upcoming

        init() {
            fetchJson()
        }

        func fetchJson() {
            guard let url = URL(string: "https://async-swift.github.io/jsonstorage/asyncswift.json") else { return }
            let request = URLRequest(url: url)
            let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                guard let response = response as? HTTPURLResponse else { return }
                if response.statusCode == 200 {
                    guard let data = data else { return }
                    DispatchQueue.main.async { [weak self] in
                        if let self = self {
                            do {
                                let decodedData = try JSONDecoder().decode(JSONResponse.self, from: data)
                                withAnimation {
                                    self.response = decodedData
                                }
                                self.calculateEventStatus()
                            } catch let error {
                                print("❌ \(error.localizedDescription)")
                            }
                        }
                    }
                }
            }
            dataTask.resume()
        }

        func calculateEventStatus() {
            let formatter = DateFormatter.calendarFormatter
            let start = formatter.date(from: self.response.event.startDate)
            let end = formatter.date(from: self.response.event.endDate)
            let current = Date()

            if let start = start, let end = end {
                if current < start {
                    self.eventStatus = .upcoming
                } else if start <= current && current < end {
                    self.eventStatus = .onProgress
                } else if current > end {
                    self.eventStatus = .done
                }
            }
        }
    }
}

extension EventView {
    enum EventStatus: String {
        case upcoming = "예정된 행사"
        case onProgress = "진행중인 행사"
        case done = "지나간 행사"
    }
}
