//
//  ScheduleView.swift
//  AsyncSwift
//
//  Created by Kim Insub on 2022/09/06.
//

/* TODO: 내용
 1. light mode only
 2. lock landscape
*/

import SwiftUI

struct EventView: View {

    @ObservedObject var observed: Observed

    init() {
        observed = Observed()
    }

    var body: some View {
        NavigationView {
            ScrollView {
                Header
                LazyVStack {
                    ForEach(observed.response.sessions) { session in
                        makeSessionCell(for: session)
                    }
                }
            }
            .navigationTitle(Tab.event.title)
        }
    }
}

private extension EventView {

    var Header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(observed.response.event.subject)
                .font(.title)
                .fontWeight(.bold)
            HStack {
                Text(observed.response.event.title)
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 8)
                    .background(Color.seminarOrange)
                    .cornerRadius(20)
                Text(observed.eventStatus.rawValue)
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(Color.accentColor)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.accentColor, lineWidth: 1)
                    )
                Spacer()
            }
            NavigationLink {
                EventDetailView(event: observed.response.event)
            } label: {
                Text("세미나 살펴보기 \(Image(systemName: "arrow.right"))")
                    .font(.footnote)
                    .fontWeight(.bold)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 30)
    }

    @ViewBuilder
    func makeSessionCell(for session: Session) -> some View {
        NavigationLink {
            SessionView(session: session)
        } label: {
            VStack {
                customDivider
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(session.title)
                            .font(.headline)
                            .foregroundColor(.black)
                            .multilineTextAlignment(.leading)
                        Text("\(session.speaker.name) 님")
                            .font(.body)
                            .foregroundColor(.black)
                    }
                    .padding(.vertical, 30)
                    Spacer()
                    VStack {
                        Image(systemName: "chevron.right")
                            .font(Font.system(size: 30, weight: .light))
                            .foregroundColor(.black)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}
