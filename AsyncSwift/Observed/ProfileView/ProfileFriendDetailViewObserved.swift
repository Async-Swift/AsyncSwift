//
//  ProfileFriendDetailViewObserved.swift
//  AsyncSwift
//
//  Created by Kim Insub on 2022/11/04.
//

import Foundation

final class ProfileFriendDetailViewObserved: ObservableObject {

    let user: User

    init(user: User) {
        self.user = user
    }

    func hasLinkedInURL() -> Bool {
        if user.linkedInURL.isEmpty {
            return false
        } else {
            return true
        }
    }

    func hasProfileURL() -> Bool {
        if user.profileURL.isEmpty {
            return false
        } else {
            return true
        }
    }
}
