//
//  User.swift
//  AsyncSwift
//
//  Created by Kim Insub on 2022/11/03.
//

import Foundation

struct User: Identifiable {
    init() {
        self.id = ""
        self.name = ""
        self.nickname = ""
        self.role = ""
        self.description = ""
        self.linkedInURL = ""
        self.profileURL = ""
        self.friends = []
    }

    init(
        id: String,
        name: String,
        nickname: String,
        role: String,
        description: String,
        linkedInURL: String,
        profileURL: String,
        friends: [String]
    ) {
        self.id = id
        self.name = name
        self.nickname = nickname
        self.role = role
        self.description = description
        self.linkedInURL = linkedInURL
        self.profileURL = profileURL
        self.friends = friends
    }

    var id: String
    var name: String
    var nickname: String
    var role: String
    var description: String
    var linkedInURL: String
    var profileURL: String
    var friends: [String]
}
