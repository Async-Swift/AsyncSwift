//
//  ProfileFriendsListViewObserved.swift
//  AsyncSwift
//
//  Created by Kim Insub on 2022/11/03.
//

import Combine
import Foundation

// TODO
// 1. friendsList 스캔후 KeyChain 에 저장

final class ProfileFriendsListViewObserved: ObservableObject {
    @Published var friends: [User] = []

    let friendList = ["95FD8056-3461-4B36-BE16-F6F0DB939E36", "95FD8056-3461-4B36-BE16-F6F0DB939E36", "95FD8056-3461-4B36-BE16-F6F0DB939E36"]

    func onAppear() {
        getFriendsByID()
    }
}

private extension ProfileFriendsListViewObserved {
    func getFriendsByID() {
        friends = []
        for friendID in friendList {
            FirebaseManager.shared.getUserBy(id: friendID) { user in
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.friends.append(user)
                }
            }
        }
    }
}
