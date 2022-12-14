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
    @Published var isShowingFailureAlert = false
    @Published var isShowingScanErrorAlert = false
    @Published var user: User = .init()
    @Published var scannedFriend: User = .init()
    private let keyChainManager = KeyChainManager()

    var userID: String? {
        didSet {
            let _ = keyChainManager.addItem(key: "userID", pwd: userID ?? "")
        }
    }

    init() {
        guard let userid = keyChainManager.getItem(key: "userID") else { return }
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

private extension ProfileViewObserved {
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
        guard isNewFriend(id: id)
        else {
            isShowingScanner = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                guard let self = self else { return }
                self.isShowingFailureAlert = true
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

