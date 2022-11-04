//
//  ProfileFriendDetailViewObserved.swift
//  AsyncSwift
//
//  Created by Kim Insub on 2022/11/04.
//

import Foundation

final class ProfileFriendDetailViewObserved: ObservableObject {

    @Published var isShowingLinkedInSheet = false
    @Published var isShowingProfileSheet = false

    let user: User

    init(user: User) {
        self.user = user
    }

    func hasProfileURL() -> Bool {
        if user.profileURL.isEmpty {
            return false
        } else {
            return true
        }
    }

    func hasLinkedInURL() -> Bool {
        if user.linkedInURL.isEmpty {
            return false
        } else {
            return true
        }
    }
}
