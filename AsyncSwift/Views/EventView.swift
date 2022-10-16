//
//  ScheduleView.swift
//  AsyncSwift
//
//  Created by Kim Insub on 2022/09/06.
//

import SwiftUI

struct EventView: View {

    @ObservedObject var observed: Observed

    init() {
        observed = Observed()
    }

    var body: some View {
        NavigationView {
            ScrollView {
                if observed.isLoading {
                    VStack(spacing: 0) {
                        onLoadingHeader
                        VStack(alignment: .leading, spacing: 0) {
                            ForEach(observed.onLoadingCells, id: \.self) { _ in
                                makeOnLoadingCell()
                            }
                        }
                    }
                } else {
                    Header
                    LazyVStack {
                        ForEach(observed.event.sessions) { session in
                            makeSessionCell(for: session)
                        }
                    }
                }
            }
            .navigationTitle(Tab.event.title)
        }
    }
}

private extension EventView {

    var onLoadingHeader: some View {
        HStack {
            VStack(alignment: .leading, spacing: 9) {
                Rectangle()
                    .frame(width: 202, height: 30)
                    .cornerRadius(4)
                    .foregroundColor(.gray)
                    .opacity(0.8)
                HStack {
                    Rectangle()
                        .frame(width: 151, height: 21)
                        .cornerRadius(13)
                        .foregroundColor(.gray)
                    Rectangle()
                        .frame(width: 70, height: 21)
                        .cornerRadius(13)
                        .foregroundColor(.gray)
                }
                .opacity(0.4)
                .padding(.bottom, 2)
                Rectangle()
                    .frame(width: 106, height: 13)
                    .cornerRadius(4)
                    .foregroundColor(.gray)
                    .opacity(0.2)
            }
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 32)
    }

    var Header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(observed.event.subject)
                .font(.title)
                .fontWeight(.bold)
            HStack {
                Text(observed.event.title)
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
                    .foregroundColor(observed.eventStatus.statusColor)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(observed.eventStatus.statusColor, lineWidth: 1)
                    )
                Spacer()
            }
            NavigationLink {
                EventDetailView(event: observed.event)
            } label: {
                Text("\(observed.event.type) 살펴보기 \(Image(systemName: "arrow.right"))")
                    .font(.footnote)
                    .fontWeight(.bold)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 30)
    }

    @ViewBuilder
    func makeOnLoadingCell() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            customDivider
            VStack(alignment: .leading, spacing: 0) {
                Rectangle()
                    .frame(width: 250, height: 20)
                    .cornerRadius(4)
                    .foregroundColor(.gray)
                    .opacity(0.4)
                    .padding(.bottom, 4)
                Rectangle()
                    .frame(width: 70, height: 20)
                    .cornerRadius(4)
                    .foregroundColor(.gray)
                    .opacity(0.2)
            }
            .padding(.horizontal)
            .padding(.bottom, 27)
            .padding(.top, 31)
        }
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
