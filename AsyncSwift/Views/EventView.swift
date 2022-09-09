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

    var event: Event
    var sessions: [Session]

    struct Event {

        var title: String
        var detailTitle: String
        var subject: String
        var description: [Paragraph]
        var date: String
        var time: String
        var location: String
        var detailLocation: String
        var address: String
        var hashTags: String

        struct Paragraph: Hashable {
            var content: String
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
                .font(.system(size: 28, weight: .bold))
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
                    .font(.system(size: 13))
                    .fontWeight(.bold)
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
                CustomDivider()
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
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(Font.system(size: 30, weight: .light))
                            .foregroundColor(.black)
                        Spacer()
                    }
                }
                .padding(.horizontal, 16)
            }
        }
        .frame(minHeight: 109)
    }
}

//struct ScheduleView_Previews: PreviewProvider {
//    static var previews: some View {
//        EventView()
//    }
//}

struct Mock {
    static let data: EventModel = EventModel(
        event: EventModel.Event(
            title: "AsyncSwift Seminar 002",
            detailTitle: "AsyncSwift 002",
            subject: "생산성 향상[생산썽 향:상]",
            description: [
                EventModel.Event.Paragraph(content: "우리가 동료들과 함께 프로젝트를 더 잘 협업할 수 있는 방법은 무엇일까요?"),
                EventModel.Event.Paragraph(content: "다 함께 고민하고, 다 같이 나아갈 수 있는 생산성 향상이 힌트가 될 수 있지 않을까 생각이 되었습니다."),
                EventModel.Event.Paragraph(content: "같이 잘 나아가고 성장하기 위해 가을의 문턱에서 함께 이야기를 나눠보려합니다.")
            ],
            date: "Thu, September 22, 2022",
            time: "7:00 PM – 10:00 PM KST",
            location: "체인지업 그라운드 포항",
            detailLocation: "2층 미디어월",
            address: "청암로 87, 남구, 포항시, 경상북도 790-390",
            hashTags: "#리팩토링 #테스트코드 #모듈화 #디자인패턴 #Architecture"
        ),
        sessions: [
            EventModel.Session(
                id: 0,
                title: "내일 지구가 멸망하더라도 테스트는 같게 동작해야한다.",
                description: [
                    EventModel.Session.Paragraph(content: "- XCode에서 테스팅을 진행하는 이유와, 간략한 예제를 통해 테스팅을 진행합니다."),
                    EventModel.Session.Paragraph(content: "- 테스트 더블이 필요한 상황(네트워크와 무관하게 Response처리를 검사해야하는 경우)을 가정할 때 테스트 방식을 소개합니다."),
                    EventModel.Session.Paragraph(content: "- 길어지는 경우에 이렇게 들어갑니다. XCode에서 테스팅을 진행하는 이유와, 간략한 예제를 통해 테스팅을 진행합니다."),
                    EventModel.Session.Paragraph(content: "- 밑의 여백을 추가해요.테스트 더블이 필요한 상황(네트워크와 무관하게 Response처리를 검사해야하는 경우)을 가정할 때 테스트 방식을 소개합니다.")
                ],
                speaker: EventModel.Session.Speaker(
                    name: "김찬우",
                    imageURL: "",
                    role: "Coda, iOS 교육 설계",
                    description: "iOS 개발과 교육 그 사이 어딘가에서 머무르고 있습니다.\n서비스를 통해 세상의 문제를 해결하는 것을 즐거워합니다.")
            ),
            EventModel.Session(
                id: 1,
                title: "Coupang의 MVVM",
                description: [
                    EventModel.Session.Paragraph(content: "- XCode에서 테스팅을 진행하는 이유와, 간략한 예제를 통해 테스팅을 진행합니다."),
                    EventModel.Session.Paragraph(content: "- 테스트 더블이 필요한 상황(네트워크와 무관하게 Response처리를 검사해야하는 경우)을 가정할 때 테스트 방식을 소개합니다."),
                    EventModel.Session.Paragraph(content: "- 길어지는 경우에 이렇게 들어갑니다. XCode에서 테스팅을 진행하는 이유와, 간략한 예제를 통해 테스팅을 진행합니다."),
                    EventModel.Session.Paragraph(content: "- 밑의 여백을 추가해요.테스트 더블이 필요한 상황(네트워크와 무관하게 Response처리를 검사해야하는 경우)을 가정할 때 테스트 방식을 소개합니다.")
                ],
                speaker: EventModel.Session.Speaker(
                    name: "권문범",
                    imageURL: "",
                    role: "Coda, iOS 교육 설계",
                    description: "iOS 개발과 교육 그 사이 어딘가에서 머무르고 있습니다.\n서비스를 통해 세상의 문제를 해결하는 것을 즐거워합니다.")
            ),
            EventModel.Session(
                id: 2,
                title: "내일 지구가 멸망하더라도 테스트는 같게 동작해야한다",
                description: [
                    EventModel.Session.Paragraph(content: "- XCode에서 테스팅을 진행하는 이유와, 간략한 예제를 통해 테스팅을 진행합니다."),
                    EventModel.Session.Paragraph(content: "- 테스트 더블이 필요한 상황(네트워크와 무관하게 Response처리를 검사해야하는 경우)을 가정할 때 테스트 방식을 소개합니다."),
                    EventModel.Session.Paragraph(content: "- 길어지는 경우에 이렇게 들어갑니다. XCode에서 테스팅을 진행하는 이유와, 간략한 예제를 통해 테스팅을 진행합니다."),
                    EventModel.Session.Paragraph(content: "- 밑의 여백을 추가해요.테스트 더블이 필요한 상황(네트워크와 무관하게 Response처리를 검사해야하는 경우)을 가정할 때 테스트 방식을 소개합니다.")
                ],
                speaker: EventModel.Session.Speaker(
                    name: "김찬우",
                    imageURL: "",
                    role: "Coda, iOS 교육 설계",
                    description: "iOS 개발과 교육 그 사이 어딘가에서 머무르고 있습니다.\n서비스를 통해 세상의 문제를 해결하는 것을 즐거워합니다.")
            ),
            EventModel.Session(
                id: 3,
                title: "내일 지구가 멸망하더라도 테스트는 같게 동작해야한다",
                description: [
                    EventModel.Session.Paragraph(content: "- XCode에서 테스팅을 진행하는 이유와, 간략한 예제를 통해 테스팅을 진행합니다."),
                    EventModel.Session.Paragraph(content: "- 테스트 더블이 필요한 상황(네트워크와 무관하게 Response처리를 검사해야하는 경우)을 가정할 때 테스트 방식을 소개합니다."),
                    EventModel.Session.Paragraph(content: "- 길어지는 경우에 이렇게 들어갑니다. XCode에서 테스팅을 진행하는 이유와, 간략한 예제를 통해 테스팅을 진행합니다."),
                    EventModel.Session.Paragraph(content: "- 밑의 여백을 추가해요.테스트 더블이 필요한 상황(네트워크와 무관하게 Response처리를 검사해야하는 경우)을 가정할 때 테스트 방식을 소개합니다.")
                ],
                speaker: EventModel.Session.Speaker(
                    name: "김찬우",
                    imageURL: "",
                    role: "Coda, iOS 교육 설계",
                    description: "iOS 개발과 교육 그 사이 어딘가에서 머무르고 있습니다.\n서비스를 통해 세상의 문제를 해결하는 것을 즐거워합니다.")
            ),
            EventModel.Session(
                id: 4,
                title: "내일 지구가 멸망하더라도 테스트는 같게 동작해야한다",
                description: [
                    EventModel.Session.Paragraph(content: "- XCode에서 테스팅을 진행하는 이유와, 간략한 예제를 통해 테스팅을 진행합니다."),
                    EventModel.Session.Paragraph(content: "- 테스트 더블이 필요한 상황(네트워크와 무관하게 Response처리를 검사해야하는 경우)을 가정할 때 테스트 방식을 소개합니다."),
                    EventModel.Session.Paragraph(content: "- 길어지는 경우에 이렇게 들어갑니다. XCode에서 테스팅을 진행하는 이유와, 간략한 예제를 통해 테스팅을 진행합니다."),
                    EventModel.Session.Paragraph(content: "- 밑의 여백을 추가해요.테스트 더블이 필요한 상황(네트워크와 무관하게 Response처리를 검사해야하는 경우)을 가정할 때 테스트 방식을 소개합니다.")
                ],
                speaker: EventModel.Session.Speaker(
                    name: "김찬우",
                    imageURL: "",
                    role: "Coda, iOS 교육 설계",
                    description: "iOS 개발과 교육 그 사이 어딘가에서 머무르고 있습니다.\n서비스를 통해 세상의 문제를 해결하는 것을 즐거워합니다.")
            ),
            EventModel.Session(
                id: 5,
                title: "내일 지구가 멸망하더라도 테스트는 같게 동작해야한다",
                description: [
                    EventModel.Session.Paragraph(content: "- XCode에서 테스팅을 진행하는 이유와, 간략한 예제를 통해 테스팅을 진행합니다."),
                    EventModel.Session.Paragraph(content: "- 테스트 더블이 필요한 상황(네트워크와 무관하게 Response처리를 검사해야하는 경우)을 가정할 때 테스트 방식을 소개합니다."),
                    EventModel.Session.Paragraph(content: "- 길어지는 경우에 이렇게 들어갑니다. XCode에서 테스팅을 진행하는 이유와, 간략한 예제를 통해 테스팅을 진행합니다."),
                    EventModel.Session.Paragraph(content: "- 밑의 여백을 추가해요.테스트 더블이 필요한 상황(네트워크와 무관하게 Response처리를 검사해야하는 경우)을 가정할 때 테스트 방식을 소개합니다.")
                ],
                speaker: EventModel.Session.Speaker(
                    name: "김찬우",
                    imageURL: "",
                    role: "Coda, iOS 교육 설계",
                    description: "iOS 개발과 교육 그 사이 어딘가에서 머무르고 있습니다.\n서비스를 통해 세상의 문제를 해결하는 것을 즐거워합니다.")
            )
           ]
    )
}
