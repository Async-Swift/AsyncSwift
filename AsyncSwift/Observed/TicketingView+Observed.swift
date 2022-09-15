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

        var hasAvailableTicket: Bool {
            let currentDate = Date()
            return currentDate <= DateFormatter.calendarFormatter.date(from: ticketing?.currentTicket?.date ?? "") ?? Date()
        }

        var isTicketingLinkDisabled: Bool { ticketing?.currentTicket?.ticketingURL == nil }

        func onAppear() {
            guard
                let url = URL(string: "https://raw.githubusercontent.com/Async-Swift/jsonstorage/main/ticketing.json")
            else { return }


            let request = URLRequest(url: url)
            let dataTask = URLSession.shared.dataTask(with: request) { data, response, _ in
               guard
                   let response = response as? HTTPURLResponse,
                   response.statusCode == 200,
                   let data = data
               else { return }

               DispatchQueue.main.async { [weak self] in
                   do {
                       let ticketing = try JSONDecoder().decode(Ticketing.self, from: data)
                       self?.ticketing = ticketing
                   } catch {
                       self?.ticketing = nil
                   }
               }
            }

            dataTask.resume()
        }

        func didTappedTicketingButton() {
            isActivatedWebViewNavigationLink = true
        }
    }
}
