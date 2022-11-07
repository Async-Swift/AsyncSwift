//
//  ProfileView+Observed.swift
//  AsyncSwift
//
//  Created by Kim Insub on 2022/10/16.
//

import CodeScanner
import CoreImage.CIFilterBuiltins
import Combine
import UIKit

@MainActor
final class ProfileViewObserved: ObservableObject {
    @Published var hasRegisteredProfile = false
    @Published var isLoading = true
    @Published var isShowingFriends = false
    @Published var isShowingEdit = false
    @Published var isShowingScanner = false
    @Published var isShowingUserDetail = false
    @Published var user: User = User(
        id: "",
        name: "",
        nickname: "",
        role: "",
        description: "",
        linkedInURL: "",
        profileURL: "",
        friends: []
    )
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

    var userID: String? {
        didSet {
            let _ = KeyChain.shared.addItem(key: "userID", pwd: userID ?? "")
        }
    }

    init() {
        guard let userid = KeyChain.shared.getItem(key: "userID") else { return }
        self.hasRegisteredProfile = true
        self.userID = userid as? String
    }

    func onAppear() {
        guard hasRegisteredProfile else { return }
        Task {
            await getUserByID()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
                guard let self = self else { return }
                self.isLoading = false
            }
        }
    }

    func didTapCloseButton() {
        isShowingScanner = false
    }

    func getQRCodeImage() -> UIImage {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        let data = Data(userID?.utf8 ?? "".utf8)
        filter.setValue(data, forKey: "inputMessage")
        guard let qrCodeImage = filter.outputImage,
              let qrCodeImage = context.createCGImage(qrCodeImage, from: qrCodeImage.extent)
        else { return UIImage(systemName: "xmark") ?? UIImage() }
        return UIImage(cgImage: qrCodeImage)
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

private extension ProfileViewObserved {
    func handleScanSuccess(id: String) async {
        guard (UUID(uuidString: id)) != nil else { return }
        guard isNewFriend(id: id) else { return }
        user.friends.append(id)
        FirebaseManager.shared.editUser(user: self.user)
        isShowingScanner = false
        isShowingUserDetail = true
    }

    func getUserByID() async {
        FirebaseManager.shared.getUserBy(id: self.userID ?? "") { [weak self] user in
            guard let self = self else { return }
            self.user = user
        }
    }

    func getFriendByID(id: String) async {
        FirebaseManager.shared.getUserBy(id: id) { [weak self] user in
            guard let self = self else { return }
            self.scannedFriend = user
        }
    }

    func isNewFriend(id: String) -> Bool {
        return !user.friends.contains(id)
    }
}

