//
//  ProfileFriendDetailViewObserved.swift
//  AsyncSwift
//
//  Created by Kim Insub on 2022/11/04.
//

import SwiftUI

@MainActor
final class ProfileFriendDetailViewObserved: ObservableObject {
    @Binding var inActive: Bool
    @Published var isShowingLinkedInSheet = false
    @Published var isShowingProfileSheet = false
    @Published var isShowingConfirmAlert = false
    let previous: PreviousView
    let friend: User
    var user: User
    var hasProfileURL: Bool {
        get {
            !user.profileURL.isEmpty
        }
    }
    var hasLinkedInURL: Bool {
        get {
            !user.linkedInURL.isEmpty
        }
    }

    init(inActive: Binding<Bool>, user: User, friend: User, previous: PreviousView) {
        self._inActive = inActive
        self.friend = friend
        self.user = user
        self.previous = previous
    }

    func didTapDoneButton() {
        inActive = false
    }

    func didTapDeleteButton() {
        isShowingConfirmAlert = true
    }

    func didConfirmDelete() {
        Task {
            await removeFriendFromList()
            inActive = false
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

enum PreviousView {
    case ProfileView
    case ListView
}
