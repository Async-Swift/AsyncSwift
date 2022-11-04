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
    @Published var friendsList: [User] = []
    var friends: [String] = []

    init(friends: [String]) {
        self.friends = friends
    }

    func onAppear() {
        getFriendsByID()
    }
}

private extension ProfileFriendsListViewObserved {
    func getFriendsByID() {
        friendsList = []
        for friendID in friends {
            FirebaseManager.shared.getUserBy(id: friendID) { user in
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.friendsList.append(user)
                }
            }
        }
    }
}
