//
//  ProfileFriendsListViewObserved.swift
//  AsyncSwift
//
//  Created by Kim Insub on 2022/11/03.
//

import Combine
import CodeScanner
import SwiftUI

// TODO
// 1. friendsList 스캔후 KeyChain 에 저장

final class ProfileFriendsListViewObserved: ObservableObject {
    @Binding var inActive: Bool
    @Published var isLoading = true
    @Published var isShowingScanner = false
    @Published var friendsList: [User] = []
    var user: User

    init(inActive: Binding<Bool>, user: User) {
        self._inActive = inActive
        self.user = user
    }

    func onAppear() {
        getFriendsByID()
    }

    func didTapXButton() {
        self.isShowingScanner = false
    }

    func handleScan(result: Result<ScanResult, ScanError>) {
        switch result {
        case .success(let success):
            let uuidString = success.string
            guard (UUID(uuidString: uuidString)) != nil else { return }
            guard isNewFriend(id: uuidString) else { return }
            user.friends.append(uuidString)
            FirebaseManager.shared.editUser(user: user)
            self.isShowingScanner = false
            self.inActive = false
        case .failure(let failure):
            print(failure)
        }
    }
}

private extension ProfileFriendsListViewObserved {
    func getFriendsByID() {
        friendsList = []
        for friendID in user.friends {
            FirebaseManager.shared.getUserBy(id: friendID) { user in
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.friendsList.append(user)
                }
            }
        }
        self.isLoading = false
    }

    func isNewFriend(id: String) -> Bool {
        return !user.friends.contains(id)
    }
}
