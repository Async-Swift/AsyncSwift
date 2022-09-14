//
//  TicketingView+Observed.swift
//  AsyncSwift
//
//  Created by Eunyeong Kim on 2022/09/09.
//

import Combine

extension TicketingView {

    final class Observed: ObservableObject {
        @Published var isActivatedWebViewNavigationLink = false

        let upcomingEventURL = "https://www.eventbrite.com/e/asyncswift-seminar-002-tickets-408509251167"

        func didTappedTicketingButton() {
            isActivatedWebViewNavigationLink = true
        }
    }
}
