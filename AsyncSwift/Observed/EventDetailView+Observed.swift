//
//  EventDetailView+Observed.swift
//  AsyncSwift
//
//  Created by Kim Insub on 2022/09/09.
//

import Foundation
import EventKit

extension EventDetailView {
    final class Observed: ObservableObject {

        @Published var isShowingSheet = false
        @Published var isShowingAlert = false
        @Published var isShowingSuccessAlert = false
        @Published var isShowingFailureAlert = false

        let data = Mock.data

        func additionConfirmed() {
            addEventOnCalendar { isSuccess in
                DispatchQueue.main.async {
                    switch isSuccess {
                    case true:
                        self.isShowingSuccessAlert = true
                    case false:
                        self.isShowingFailureAlert = true
                    }
                }
            }
        }

        func addEventOnCalendar(completion: @escaping ((Bool) -> Void) ) {
            let eventStore = EKEventStore()

            eventStore.requestAccess(to: .event) { (granted, error) in
                if let error = error {
                    print("failed to save event with error : \(error) or access not granted")
                    return
                }
                let event = EKEvent(eventStore: eventStore)
                let formatter = DateFormatter.calendarFormatter
                event.title = self.data.event.title
                event.location = self.data.event.location
                event.startDate = formatter.date(from: self.data.event.startDate)
                event.endDate = formatter.date(from: self.data.event.endDate)
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

