//
//  TicketingView+Observed.swift
//  AsyncSwift
//
//  Created by Eunyeong Kim on 2022/09/09.
//

import Combine
import Foundation

extension TicketingView {
    final class Observed: ObservableObject {
        @Published var ticketing: Ticketing?
        @Published var isActivatedWebViewNavigationLink = false
        var cancellable = Set<AnyCancellable>()

        var hasAvailableTicket: Bool {
            let currentDate = Date()
            return currentDate <= DateFormatter.calendarFormatter.date(from: ticketing?.currentTicket?.date ?? "") ?? Date()
        }

        var isTicketingLinkDisabled: Bool {
            ticketing?.currentTicket?.ticketingURL == nil && !hasAvailableTicket
        }
        
        func getTicketingData() {
            let urlString = "https://raw.githubusercontent.com/Async-Swift/jsonstorage/main/ticketing.json"
            let url = URL(string: urlString)!
            URLSession.shared.dataTaskPublisher(for: url)
                .tryMap() { element -> Data in
                    guard let httpResponse = element.response as? HTTPURLResponse,
                          httpResponse.statusCode == 200
                    else { throw URLError(.badServerResponse) }
                    return element.data
                }
                .decode(type: Ticketing.self, decoder: JSONDecoder())
                .receive(on: RunLoop.main)
                .sink { _ in
                    
                } receiveValue: { [weak self] event in
                    self?.ticketing = event
                }
                .store(in: &cancellable)
        }

        func didTappedTicketingButton() {
            isActivatedWebViewNavigationLink = true
        }
    }
}
