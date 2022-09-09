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

        let eventStore : EKEventStore = EKEventStore()

        func addEventOnCalendar() {
            eventStore.requestAccess(to: .event) { (granted, error) in
                if let error = error {
                    print("failed to save event with error : \(error) or access not granted")
                    return
                }
                print("granted \(granted)")
                let event: EKEvent = EKEvent(eventStore: self.eventStore)
                let formatter = DateFormatter()
                let startDate = formatter.date(from: self.data.event.startDate)
                let endDate = formatter.date(from: self.data.event.endDate)
                formatter.dateFormat = "yyyy/MM/dd HH:mm"
                event.title = self.data.event.title
                event.location = self.data.event.location
                event.startDate = startDate
                event.endDate = endDate
                event.calendar = self.eventStore.defaultCalendarForNewEvents
                do {
                    try self.eventStore.save(event, span: .thisEvent)
                } catch let error as NSError {
                    print("failed to save event with error : \(error)")
                }
                print("Saved Event")
            }
        }
    }
}

