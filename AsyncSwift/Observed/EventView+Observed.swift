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

        @Published var event = Event()
        @Published var eventStatus: EventStatus = .upcoming

        init() {
            fetchJson()
        }

        func fetchJson() {

            guard let url = URL(string: "https://async-swift.github.io/jsonstorage/asyncswift.json") else { return }
            let request = URLRequest(url: url)
            let dataTask = URLSession.shared.dataTask(with: request) { data, response, _ in
               guard
                   let response = response as? HTTPURLResponse,
                   response.statusCode == 200,
                   let data = data
               else { return }
               DispatchQueue.main.async { [weak self] in
                   guard let self = self else { return }
                   do {
                       let decodedData = try JSONDecoder().decode(Event.self, from: data)
                       withAnimation {
                           self.event = decodedData
                       }
                       self.calculateEventStatus()
                   } catch let error {
                       print("❌ \(error.localizedDescription)")
                   }
               }
            }
            dataTask.resume()
        }

        func calculateEventStatus() {
            let formatter = DateFormatter.calendarFormatter
            guard
                let start = formatter.date(from: event.startDate),
                let end = formatter.date(from: event.endDate)
            else { return }
            let current = Date()

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

extension EventView {
    enum EventStatus: String {
        case upcoming = "예정된 행사"
        case onProgress = "진행중인 행사"
        case done = "지나간 행사"
    }
}
