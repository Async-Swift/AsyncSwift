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

        @Published var showSheet = false
        @Published var showingAlert = false
        let data = Mock.data

        func addEventOnCalendar() {
            let eventStore: EKEventStore = EKEventStore()

            eventStore.requestAccess(to: .event) { (granted, error) in
                if let error = error {
                    print("failed to save event with error : \(error) or access not granted")
                    return
                }
                print("granted \(granted)")
                let event: EKEvent = EKEvent(eventStore: eventStore)
                let formatter = DateFormatter.calendarFormatter
                let startDate = formatter.date(from: self.data.event.startDate)
                let endDate = formatter.date(from: self.data.event.endDate)
                event.title = self.data.event.title
                event.location = self.data.event.location
                event.startDate = startDate
                event.endDate = endDate
                event.calendar = eventStore.defaultCalendarForNewEvents
                do {
                    try eventStore.save(event, span: .thisEvent)
                } catch let error as NSError {
                    print("failed to save event with error : \(error)")
                }
                print("Saved Event")
            }
        }
    }
}

