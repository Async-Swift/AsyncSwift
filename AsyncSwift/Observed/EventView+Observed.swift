//
//  EventView+Observed.swift
//  AsyncSwift
//
//  Created by Kim Insub on 2022/09/08.
//

import SwiftUI


final class EventViewObserved: ObservableObject {

    @Published var event = Event()
    @Published var eventStatus: EventStatus = .upcoming
    @Published var isLoading = true
    let onLoadingCells = Array(repeating: [0], count: 6)

    init() {
        self.fetchJson {
            self.calculateEventStatus()
            self.isLoading = false
        }
    }

    func fetchJson(completion: @escaping () -> Void) {
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
                   self.event = decodedData
                   completion()
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
        let currentDate = Date()

        if currentDate < start {
            self.eventStatus = .upcoming
        } else if start <= currentDate && currentDate < end {
            self.eventStatus = .onProgress
        } else if currentDate > end {
            self.eventStatus = .done
        }
    }
}


extension EventViewObserved {
    enum EventStatus: String {
        case upcoming = "예정된 행사"
        case onProgress = "진행중인 행사"
        case done = "지나간 행사"

        var statusColor: Color {
            switch self {
            case .upcoming: return Color.accentColor
            case .onProgress: return Color.asyncBlue
            case .done: return Color.black
            }
        }
    }
}
