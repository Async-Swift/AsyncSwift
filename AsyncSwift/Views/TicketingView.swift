//
//  TicketView.swift
//  AsyncSwift
//
//  Created by Kim Insub on 2022/09/06.
//

import SwiftUI

struct TicketingView: View {
	var body: some View {
		NavigationView {
			ScrollView {
				VStack(spacing: 30) {
					Image("Seminar002Ticket")
						.resizable()
						.aspectRatio(contentMode: .fit)
						.shadow(color: Color(.sRGB, red: 0, green: 0, blue: 0, opacity: 0.15), radius: 20, x: 0, y: 4)

					Image("UpcomingConference001")
						.resizable()
						.aspectRatio(contentMode: .fit)
				}
					.aspectRatio(contentMode: .fit)
					.padding(30)

			}
				.navigationTitle("Ticketing")
		} // NavigationView
	} // body
} // View

struct TicketView_Previews: PreviewProvider {
	static var previews: some View {
		TicketingView()
	}
}
