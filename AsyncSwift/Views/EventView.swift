//
//  ScheduleView.swift
//  AsyncSwift
//
//  Created by Kim Insub on 2022/09/06.
//

/* TODO: 내용
 1. light mode only
 2. lock landscape
 2. 리스트의 세버론 웨이트 라이트로 적용하기
 3. 디바이더 너비 키우기
 4. 예정된 행사 테그 구현하기
 */

import SwiftUI

struct EventModel {

    let event: Event
    let sessions: [Session]

    struct Event {

        var title: String
        var detailTitle: String
        var subject: String
        var description: [Paragraph]
        var date: String
        var startDate: String
        var endDate: String
        var time: String
        var location: String
        var address: String
        var hashTags: String
        var addressURLs: AddressURLs

        struct Paragraph: Hashable {
            var content: String
        }

        struct AddressURLs {
            var naverMapURL: String
            var kakaoMapURL: String
        }
    }

    struct Session: Identifiable {

        let id: Int
        var title: String
        var description: [Paragraph]
        var speaker: Speaker

        struct Speaker {
            var name: String
            var imageURL: String
            var role: String
            var description: String
        }

        struct Paragraph: Hashable {
            var content: String
        }
    }
}


struct EventView: View {

    private let data = Mock.data

    var body: some View {
        NavigationView {
            ScrollView {
                Header
                LazyVStack {
                    ForEach(data.sessions) { session in
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
            Text(data.event.subject)
                .font(.title)
                .fontWeight(.bold)
            HStack {
                Text(data.event.title)
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 8)
                    .background(Color.seminarOrange)
                    .cornerRadius(20)
                Spacer()
            }

            NavigationLink {
                EventDetailView(event: data.event)
            } label: {
                Text("세미나 살펴보기 \(Image(systemName: "arrow.right"))")
                    .font(.system(size: 13, weight: .bold))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 30)
    }

    @ViewBuilder
    func makeSessionCell(for session: EventModel.Session) -> some View {
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
