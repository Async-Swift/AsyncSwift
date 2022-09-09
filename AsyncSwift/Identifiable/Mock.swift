//
//  Mock.swift
//  AsyncSwift
//
//  Created by Kim Insub on 2022/09/09.
//

import Foundation

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
            startDate: "2022/09/22 19:00",
            endDate: "2022/09/22 23:00",
            time: "7:00 PM – 10:00 PM KST",
            location: "체인지업 그라운드 포항, 2층 미디어월",
            address: "청암로 87, 남구, 포항시, 경상북도 790-390",
            hashTags: "#리팩토링 #테스트코드 #모듈화 #디자인패턴 #Architecture",
            addressURLs: EventModel.Event.AddressURLs(
                naverMapURL: "https://map.naver.com/v5/entry/place/1019717788?c=14396419.6520108,4302029.7423806,15,0,0,0,dh",
                kakaoMapURL: "http://kko.to/ONFeYdS33"
            )
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
