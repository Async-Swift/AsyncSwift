//
//  ProfileFriendsListViewObserved.swift
//  AsyncSwift
//
//  Created by Kim Insub on 2022/11/03.
//

import CodeScanner
import Combine
import SwiftUI

@MainActor
final class ProfileFriendsListViewObserved: ObservableObject {
    @Binding var inActive: Bool
    @Published var isShowingUserDetail = false {
        didSet {
            if isShowingUserDetail == false {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.inActive = false
                }
            }
        }
    }
    @Published var isLoading = true
    @Published var isShowingScanner = false
    @Published var isShowingScanErrorAlert = false
    @Published var friendsList: [User] = []
    @Published var scannedFriend: User = User(
        id: "",
        name: "",
        nickname: "",
        role: "",
        description: "",
        linkedInURL: "",
        profileURL: "",
        friends: []
    )

    var user: User

    init(inActive: Binding<Bool>, user: User) {
        self._inActive = inActive
        self.user = user
    }

    func onAppear() {
        Task {
            await getFriendsByID()
            isLoading = false
        }
    }

    func didTapXButton() {
        isShowingScanner = false
    }

    func handleScan(result: Result<ScanResult, ScanError>) {
        switch result {
        case .success(let success):
            let uuidString = success.string
            handleScanSuccess(id: uuidString)
        case .failure(_):
            isShowingScanner = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                guard let self = self else { return }
                self.isShowingScanErrorAlert = true
            }
        }
    }
}

private extension ProfileFriendsListViewObserved {
    func handleScanSuccess(id: String) {
        guard (UUID(uuidString: id)) != nil
        else {
            isShowingScanner = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                guard let self = self else { return }
                self.isShowingScanErrorAlert = true
            }
            return
        }
        Task {
            user.friends.append(id)
            FirebaseManager.shared.editUser(user: self.user)
            await getFriendByID(id: id)
            isShowingScanner = false
            isShowingUserDetail = true
        }
    }

    func getFriendByID(id: String) async {
        FirebaseManager.shared.getUserBy(id: id) { [weak self] user in
            guard let self = self else { return }
            self.scannedFriend = user
        }
    }

    func getFriendsByID() async {
        friendsList = []
        for friendID in self.user.friends {
            FirebaseManager.shared.getUserBy(id: friendID) { [weak self] user in
                guard let self = self else { return }
                self.friendsList.append(user)
            }
        }
    }

    func isNewFriend(id: String) -> Bool {
        return !user.friends.contains(id)
    }
}
