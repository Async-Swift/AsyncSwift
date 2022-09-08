//
//  ScheduleView+Observed.swift
//  AsyncSwift
//
//  Created by Kim Insub on 2022/09/06.
//

import SwiftUI

extension EventView {
    final class Observed: ObservableObject {
        @Published var schedules: [Schedule] = []
    }
}
