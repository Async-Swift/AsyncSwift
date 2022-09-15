//
//  Ticketing.swift
//  AsyncSwift
//
//  Created by Eunyeong Kim on 2022/09/15.
//

import SwiftUI

struct Ticketing: Decodable {
    let currentTicket: CurrentTicket?
    let upcomingEvent: UpcomingEvent?

    struct CurrentTicket: Decodable {
        let ticketingImageURL: String
        let ticketingURL: String
        let date: String
    }

    struct UpcomingEvent: Decodable {
        let headerTitle: String
        let title: String
        let subscription: String
        private let gradientStartColor: RGBColor
        private let gradientEndColor: RGBColor

        var backgroundGradientStartColor: Color {
            makeColor(from: gradientStartColor)
        }

        var backgroundGradientEndColor: Color {
            makeColor(from: gradientEndColor)
        }

        private func makeColor(from rgbColor: RGBColor) -> Color {
            Color(
                red: rgbColor.red / 255.0,
                green: rgbColor.green / 255.0,
                blue: rgbColor.blue / 255.0,
                opacity: rgbColor.opacity / 100.0
            )
        }

        struct RGBColor: Decodable {
            let red: Double
            let green: Double
            let blue: Double
            let opacity: Double
        }
    }
}
