//
//  DateFormatter+.swift
//  AsyncSwift
//
//  Created by Kim Insub on 2022/09/09.
//

import Foundation

extension DateFormatter {
    static var calendarFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        return formatter
    }
}
