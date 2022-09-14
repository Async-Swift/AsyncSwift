//
//  SessionModel.swift
//  AsyncSwift
//
//  Created by Kim Insub on 2022/09/14.
//

import Foundation

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
