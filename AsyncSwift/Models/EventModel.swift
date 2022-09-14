//
//  EventModel.swift
//  AsyncSwift
//
//  Created by Kim Insub on 2022/09/14.
//

import Foundation

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
        self.sessions = []
    }

    var title, detailTitle, subject, type: String
    var description: [Paragraph]
    var date, startDate, endDate, time: String
    var location, address, hashTags: String
    var addressURLs: AddressURLs
    var sessions: [Session]

    enum CodingKeys: String, CodingKey {
        case title, detailTitle, subject, type
        case description = "description"
        case date, startDate, endDate, time, location, address, hashTags, addressURLs, sessions
    }

    struct Paragraph: Codable, Hashable {
        var content: String
    }

    struct AddressURLs: Codable {
        var naverMapURL: String
        var kakaoMapURL: String
    }
}
