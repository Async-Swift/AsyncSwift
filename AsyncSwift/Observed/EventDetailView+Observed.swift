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

        let eventStore : EKEventStore = EKEventStore()

        func addEventOnCalendar() {
            eventStore.requestAccess(to: .event) { (granted, error) in
                if let error = error {
                    print("failed to save event with error : \(error) or access not granted")
                } else {
                    print("granted \(granted)")

                    let event:EKEvent = EKEvent(eventStore: self.eventStore)

                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy/MM/dd HH:mm"
                    let startDate = formatter.date(from: "2022/09/22 19:00")
                    let endDate = formatter.date(from: "2022/09/22 23:00")

                    event.title = "AsyncSwift Seminar 002"
                    event.location = "포항공대 체인지업그라운드 2층 미디어월"
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
}

