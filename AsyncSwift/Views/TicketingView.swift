//
//  TicketView.swift
//  AsyncSwift
//
//  Created by Kim Insub on 2022/09/06.
//

import SwiftUI

struct TicketingView: View {
    @StateObject private var observed = Observed()

    private let shadowColor = Color(.sRGB, red: 0, green: 0, blue: 0, opacity: 0.15)
    private let corenrRadius: CGFloat = 8.0

	var body: some View {
		NavigationView {
			ScrollView {
				VStack(spacing: 30) {
                    if observed.isNeedToShowTicketingView {
                        ticketingView
                    }

                    if let upcomingEvent = observed.ticketing?.upcomingEvent {
                        makeUpcomingEventView(from: upcomingEvent)
                    } else {
                        skeletonView
                            .aspectRatio(2.75, contentMode: .fill)
                            .cornerRadius(corenrRadius)
                    }
                }
                .padding(30)

            }
            .navigationTitle("Ticketing")
        }.onAppear {
            observed.onAppear()
        }
    }
}

private extension TicketingView {
    var skeletonView: some View {
        LinearGradient(
            colors: [.skeletonBackground, .white],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .animation(.linear(duration: 3.0), value: 1.0)
    }

    var ticketingView: some View {
        NavigationLink(
            isActive: $observed.isActivatedWebViewNavigationLink
        ) {
            if let upcomingEventURL = observed.ticketing?.currentTicket?.ticketingURL {
                WebView(url: upcomingEventURL)
            }
        } label: {
            AsyncImage(
                url: URL(string: observed.ticketing?.currentTicket?.ticketingImageURL ?? ""),
                content: { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .transition(AnyTransition.opacity.animation(.easeInOut))
                },
                placeholder: {
                    skeletonView
                        .aspectRatio(0.85, contentMode: .fill)
                }
            )
            .cornerRadius(corenrRadius)
            .shadow(color: shadowColor, radius: 20, x: 0, y: 4)
        }.disabled(observed.isTicketingLinkDisabled)
    }

    @ViewBuilder
    func makeUpcomingEventView(from upcomingEvent: Ticketing.UpcomingEvent) -> some View {
        HStack(alignment: .top, spacing: 0.0) {
            VStack(alignment: .leading, spacing: 15.0) {
                Text(upcomingEvent.headerTitle)
                    .fontWeight(.bold)
                    .font(.caption2)
                VStack(alignment: .leading, spacing: 5.0) {
                    Text(upcomingEvent.title)
                        .fontWeight(.bold)
                        .font(.title2)
                    Text(upcomingEvent.subscription)
                        .fontWeight(.bold)
                        .font(.subheadline)
                }
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(
            EdgeInsets(top: 15.0, leading: 12.0, bottom: 24.0, trailing: 12.0)
        )
        .foregroundColor(.white)
        .background(
            LinearGradient(
                colors: [upcomingEvent.backgroundGradientStartColor, upcomingEvent.backgroundGradientEndColor],
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .cornerRadius(corenrRadius)
        .shadow(color: shadowColor, radius: 20, x: 0, y: 4)
    }
}

struct TicketView_Previews: PreviewProvider {
	static var previews: some View {
		TicketingView()
	}
}
