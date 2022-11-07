//
//  ProfileFriendsListViewObserved.swift
//  AsyncSwift
//
//  Created by Kim Insub on 2022/11/03.
//

import CodeScanner
import Combine
import SwiftUI

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
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.isLoading = false
            }
        }
    }

    func didTapXButton() {
        self.isShowingScanner = false
    }

    func handleScan(result: Result<ScanResult, ScanError>) {
        switch result {
        case .success(let success):
            let uuidString = success.string
            Task {
                await handleScanSuccess(id: uuidString)
                await getFriendByID(id: uuidString)
            }
        case .failure(let failure):
            print(failure)
        }
    }
}

private extension ProfileFriendsListViewObserved {
    func handleScanSuccess(id: String) async {
        guard (UUID(uuidString: id)) != nil else { return }
        guard isNewFriend(id: id) else { return }
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.user.friends.append(id)
            FirebaseManager.shared.editUser(user: self.user)
            self.isShowingScanner = false
            self.isShowingUserDetail = true
        }
    }

    func getFriendByID(id: String) async {
        FirebaseManager.shared.getUserBy(id: id) { user in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.scannedFriend = user
            }
        }
    }

    func getFriendsByID() async {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.friendsList = []
            for friendID in self.user.friends {
                FirebaseManager.shared.getUserBy(id: friendID) { user in
                    self.friendsList.append(user)
                }
            }
        }
    }

    func isNewFriend(id: String) -> Bool {
        return !user.friends.contains(id)
    }
}
