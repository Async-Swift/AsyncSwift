//
//  User.swift
//  AsyncSwift
//
//  Created by Kim Insub on 2022/11/03.
//

import Foundation

struct User: Identifiable {
    var id: String
    var name: String
    var nickname: String
    var role: String
    var description: String
    var linkedInURL: String
    var profileURL: String
    var friends: [String]
}
