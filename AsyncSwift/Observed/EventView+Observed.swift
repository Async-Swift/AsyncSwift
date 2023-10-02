//
//  EventView+Observed.swift
//  AsyncSwift
//
//  Created by Kim Insub on 2022/09/08.
//

import SwiftUI
import Combine

final class EventViewObserved: ObservableObject {

    @Published var event = Event()
    @Published var eventStatus: EventStatus = .upcoming
    @Published var isLoading = true
    let onLoadingCells = Array(repeating: [0], count: 6)
    var cancellable = Set<AnyCancellable>()
    
    func getEventData() {
        let urlString = "https://async-swift.github.io/jsonstorage/asyncswift.json"
        let url = URL(string: urlString)!
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap() { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200
                else { throw URLError(.badServerResponse) }
                return element.data
            }
            .decode(type: Event.self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .sink { _ in
                
            } receiveValue: { [weak self] event in
                self?.event = event
                self?.calculateEventStatus()
                self?.isLoading = false
            }
            .store(in: &cancellable)
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
