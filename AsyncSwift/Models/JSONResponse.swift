//
//  EventResponse.swift
//  AsyncSwift
//
//  Created by Kim Insub on 2022/09/08.
//

import Foundation

struct JSONResponse: Codable {

    init() {
        self.event = Event()
        self.sessions = []
    }
    var event: Event
    var sessions: [Session]
}

struct Event: Codable {

    init() {
        self.title = "AsyncSwift"
        self.detailTitle = "AsyncSwift"
        self.subject = ""
        self.type = "세미나"
        self.description = []
        self.date = ""
        self.startDate = ""
        self.endDate = ""
        self.time = ""
        self.location = ""
        self.address = ""
        self.hashTags = ""
        self.addressURLs = AddressURLs(naverMapURL: "", kakaoMapURL: "")
    }

    var title, detailTitle, subject, type: String
    var description: [Paragraph]
    var date, startDate, endDate, time: String
    var location, address, hashTags: String
    var addressURLs: AddressURLs

    enum CodingKeys: String, CodingKey {
        case title, detailTitle, subject, type
        case description = "description"
        case date, startDate, endDate, time, location, address, hashTags, addressURLs
    }

    struct Paragraph: Codable, Hashable {
        var content: String
    }

    struct AddressURLs: Codable {
        var naverMapURL: String
        var kakaoMapURL: String
    }
}

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

    struct Paragraph: Codable, Hashable {
        var content: String
    }

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
