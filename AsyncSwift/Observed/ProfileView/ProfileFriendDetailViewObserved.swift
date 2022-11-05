//
//  ProfileFriendDetailViewObserved.swift
//  AsyncSwift
//
//  Created by Kim Insub on 2022/11/04.
//

import SwiftUI

final class ProfileFriendDetailViewObserved: ObservableObject {
    @Binding var inActive: Bool
    @Published var isShowingLinkedInSheet = false
    @Published var isShowingProfileSheet = false
    @Published var isShowingConfirmAlert = false

    let friend: User
    var user: User

    init(inActive: Binding<Bool>, user: User, friend: User) {
        self._inActive = inActive
        self.friend = friend
        self.user = user
    }

    func hasProfileURL() -> Bool {
        if friend.profileURL.isEmpty {
            return false
        } else {
            return true
        }
    }

    func hasLinkedInURL() -> Bool {
        if friend.linkedInURL.isEmpty {
            return false
        } else {
            return true
        }
    }

    func didTapDeleteButton() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.isShowingConfirmAlert = true
        }
    }

    func didConfirmDelete() {
        Task {
            await removeFriendFromList()
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.inActive = false
            }
        }
    }
}

private extension ProfileFriendDetailViewObserved {
    func removeFriendFromList() async {
        let removedList = user.friends.filter { $0 != friend.id }
        user.friends = removedList
        FirebaseManager.shared.editUser(user: user)
    }
}
