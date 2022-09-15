//
//  TicketView.swift
//  AsyncSwift
//
//  Created by Kim Insub on 2022/09/06.
//

import SwiftUI

struct TicketingView: View {
    @StateObject private var observed = Observed()

	var body: some View {
		NavigationView {
			ScrollView {
				VStack(spacing: 30) {
                    if let upcomingEvent = observed.ticketing?.upcomingEvent {
                        makeUpcomingEventView(from: upcomingEvent)
                            .ticketingViewStyle()
                    } else {
                        skeletonView
                            .aspectRatio(2.75, contentMode: .fill)
                            .ticketingViewStyle()
                    }

                    switch observed.doesCurrentTicketExist {
                    case true:
                        ticketingView
                            .ticketingViewStyle()
                    case false:
                        emptyTicketingView
                            .ticketingViewStyle()
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

fileprivate extension TicketingView {
    struct TicketingViewStyle: ViewModifier {
        func body(content: Content) -> some View {
            content
                .cornerRadius(8.0)
                .shadow(
                    color: Color(.sRGB, red: 0, green: 0, blue: 0, opacity: 0.15),
                    radius: 20, x: 0, y: 4
                )
        }
    }
}

fileprivate extension View {
    func ticketingViewStyle() -> some View {
        modifier(TicketingView.TicketingViewStyle())
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
        }.disabled(observed.isTicketingLinkDisabled)
    }

    var emptyTicketingView: some View {
        Text("현재 판매중인 티켓이 없습니다.")
            .fontWeight(.bold)
            .font(.body)
            .foregroundColor(.emptyTicketViewForeground)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .aspectRatio(0.85, contentMode: .fill)
            .background(Color.emptyTicketViewBackground)
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
    }
}

struct TicketView_Previews: PreviewProvider {
	static var previews: some View {
		TicketingView()
	}
}
