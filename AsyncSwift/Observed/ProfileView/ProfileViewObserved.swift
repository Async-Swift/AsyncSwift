//
//  ProfileView+Observed.swift
//  AsyncSwift
//
//  Created by Kim Insub on 2022/10/16.
//

import Combine
import UIKit
import CodeScanner
import CoreImage.CIFilterBuiltins

// TODO
// 1. hasRegisteredProfile -> keyChain 으로 옮기기

final class ProfileViewObserved: ObservableObject {

    @Published var hasRegisteredProfile = UserDefaults.standard.bool(forKey: "hasRegisterProfile") {
        didSet {
            UserDefaults.standard.set(hasRegisteredProfile, forKey: "hasRegisterProfile")
        }
    }
    @Published var isLoading = true
    @Published var isShowingFriends = false
    @Published var isShowingScanner = false
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

    var userID = UserDefaults.standard.string(forKey: "userID") {
        didSet {
            UserDefaults.standard.set(userID, forKey: "userID")
        }
    }

    func onAppear() {
        if hasRegisteredProfile {
            getUserByID()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
                guard let self = self else { return }
                self.isLoading = false
            }
        }
    }

    func didTapXButton() {
        self.isShowingScanner = false
    }

    func getQRCodeImage() -> UIImage {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        let data = Data(userID?.utf8 ?? "".utf8)
        filter.setValue(data, forKey: "inputMessage")
        if let qrCodeImage = filter.outputImage {
            if let qrCodeImage = context.createCGImage(qrCodeImage, from: qrCodeImage.extent) {
                return UIImage(cgImage: qrCodeImage)
            }
        }
        return UIImage(systemName: "xmark") ?? UIImage()
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
        case .failure(let failure):
            print(failure)
        }
    }
}

private extension ProfileViewObserved {
    func getUserByID() {
        FirebaseManager.shared.getUserBy(id: self.userID ?? "") { user in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.user = user
            }
        }
    }

    func isNewFriend(id: String) -> Bool {
        return !user.friends.contains(id)
    }
}

