//
//  EventResponse.swift
//  AsyncSwift
//
//  Created by Kim Insub on 2022/09/08.
//

import Foundation

//struct EventModel: Codable {
//
//    var event: Event
//    var sessions: [Session]
//
//    struct Event: Codable {
//
//        var title: String
//        var detailTitle: String
//        var subject: String
//        var description: [Paragraph]
//        var date: String
//        var startDate: String
//        var endDate: String
//        var time: String
//        var location: String
//        var address: String
//        var hashTags: String
//        var addressURLs: AddressURLs
//
//        struct Paragraph: Hashable, Codable {
//            var content: String
//        }
//
//        struct AddressURLs: Codable {
//            var naverMapURL: String
//            var kakaoMapURL: String
//        }
//    }
//
//    struct Session: Identifiable, Codable {
//
//        let id: Int
//        var title: String
//        var description: [Paragraph]
//        var speaker: Speaker
//
//        struct Speaker: Codable {
//            var name: String
//            var imageURL: String
//            var role: String
//            var description: String
//        }
//
//        struct Paragraph: Hashable, Codable {
//            var content: String
//        }
//    }
//}

// MARK: - JSONResponse
struct JSONResponse: Codable {

    init() {
        self.event = Event()
        self.sessions = [
            Session(
                id: 0,
                title: "",
                description: [
                    Session.Paragraph(
                        content: ""
                    )
                ],
                speaker: Session.Speaker(
                    name: "",
                    imageURL: "",
                    role: "",
                    description: ""
                )
            )
        ]
    }

    var event: Event 
    var sessions: [Session]
}

// MARK: - Event
struct Event: Codable {

    init() {
        self.title = ""
        self.detailTitle = ""
        self.subject = ""
        self.description = [
            Event.Paragraph(
                content: ""
            )
        ]
        self.date = ""
        self.startDate = ""
        self.endDate = ""
        self.time = ""
        self.location = ""
        self.address = ""
        self.hashTags = ""
        self.addressURLs = Event.AddressURLs(
            naverMapURL: "",
            kakaoMapURL: ""
        )
    }
    var title, detailTitle, subject: String
    var description: [Paragraph]
    var date, startDate, endDate, time: String
    var location, address, hashTags: String
    var addressURLs: AddressURLs

    enum CodingKeys: String, CodingKey {
        case title, detailTitle, subject
        case description = "description"
        case date, startDate, endDate, time, location, address, hashTags, addressURLs
    }

    // MARK: - Description
    struct Paragraph: Codable, Hashable {
        var content: String
    }

    // MARK: - AddressURLs
    struct AddressURLs: Codable {
        var naverMapURL: String
        var kakaoMapURL: String
    }
}

// MARK: - Session
struct Session: Codable, Identifiable {
    var id: Int
    var title: String
    var description: [Paragraph]
    var speaker: Speaker

    enum CodingKeys: String, CodingKey {
        case id, title
        case description = "description"
        case speaker
    }

    // MARK: - Description
    struct Paragraph: Codable, Hashable {
        var content: String
    }

    // MARK: - Speaker
    struct Speaker: Codable {
        var name: String
        var imageURL: String
        var role, description: String

        enum CodingKeys: String, CodingKey {
            case name, imageURL, role
            case description = "description"
        }
    }
}
