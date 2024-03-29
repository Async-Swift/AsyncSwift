//
//  EventDetailView+Observed.swift
//  AsyncSwift
//
//  Created by Kim Insub on 2022/09/09.
//

import EventKit
import SwiftUI

extension EventDetailView {
    
    final class Observed: ObservableObject {

        init(event: Event) {
            self.event = event
        }

        let event: Event
        @Published var isShowingSheet = false
        @Published var isShowingAddEventConfirmationAlert = false
        @Published var isShowingAddEventSuccessAlert = false
        @Published var isShowingAddEventFailureAlert = false

        func additionConfirmed() {
            addEventOnCalendar { [weak self] isSuccess in
                DispatchQueue.main.async {
                    switch isSuccess {
                    case true:
                        self?.isShowingAddEventSuccessAlert = true
                    case false:
                        self?.isShowingAddEventFailureAlert = true
                    }
                }
            }
        }

        func addEventOnCalendar(completion: @escaping ((Bool) -> Void) ) {
            let eventStore = EKEventStore()

            eventStore.requestAccess(to: .event) { [weak self] (granted, error) in
                guard let self, error == nil else { return }
                let event = EKEvent(eventStore: eventStore)
                let formatter = DateFormatter.calendarFormatter
                event.title = self.event.title
                event.location = self.event.location
                event.startDate = formatter.date(from: self.event.startDate)
                event.endDate = formatter.date(from: self.event.endDate)
                event.calendar = eventStore.defaultCalendarForNewEvents
                do {
                    try eventStore.save(event, span: .thisEvent)
                    completion(true)
                } catch let error as NSError {
                    print("failed to save event with error : \(error)")
                    completion(false)
                }
            }
        }
    }
}

