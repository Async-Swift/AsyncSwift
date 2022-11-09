//
//  ProfileRegisterViewObserved.swift
//  AsyncSwift
//
//  Created by Kim Insub on 2022/10/28.
//

import Combine
import SwiftUI

@MainActor
final class ProfileRegisterViewObserved: ObservableObject {
    @Binding var hasRegisteredProfile: Bool
    @Binding var userID: String?

    @Published var isShowingSuccessAlert = false
    @Published var isShowingFailureAlert = false
    @Published var isShowingInputFailureAlert = false

    @Published var name = ""
    @Published var nickname = ""
    @Published var role = ""
    @Published var description = "" {
        didSet {
            if description.count >= 80 {
                description = oldValue
            }
        }
    }
    @Published var linkedInURL = "" {
        didSet {
            self.isLinkedinURLValidated = self.verifyURL(urlString: linkedInURL)
        }
    }
    @Published var profileURL = "" {
        didSet {
            self.isProfileURLValidated = self.verifyURL(urlString: profileURL)
        }
    }
    var isLinkedinURLValidated = false
    var isProfileURLValidated = false

    init(hasRegisteredProfile: Binding<Bool>, userID: Binding<String?>) {
        self._hasRegisteredProfile = hasRegisteredProfile
        self._userID = userID
    }

    func didTapRegisterButton() {
        register()
    }

    func isButtonAvailable() -> Bool {
        if !name.isEmpty && !role.isEmpty {
            return true
        } else {
            return false
        }
    }
}

private extension ProfileRegisterViewObserved {

    func register() {
        guard isButtonAvailable() else { return }
        if !linkedInURL.isEmpty && !profileURL.isEmpty {
            if isLinkedinURLValidated && isProfileURLValidated {
                handleSuccess()
            } else {
                showFailureAlert()
            }
        } else if !linkedInURL.isEmpty {
            if isLinkedinURLValidated {
                handleSuccess()
            } else {
                showFailureAlert()
            }
        } else if !profileURL.isEmpty {
            if isProfileURLValidated {
                handleSuccess()
            } else {
                showFailureAlert()
            }
        } else {
            handleSuccess()
        }
    }

    func handleSuccess() {
        Task {
            await createUser()
            hasRegisteredProfile = true
            showSuccessAlert()
        }
    }

    func showSuccessAlert() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.isShowingSuccessAlert = true
        }
    }

    func showFailureAlert() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.isShowingInputFailureAlert = true
        }
    }


    func createUser() async {
        let userId = UUID().uuidString
        let user = User(
            id: userId,
            name: name,
            nickname: nickname,
            role: role,
            description: description,
            linkedInURL: linkedInURL,
            profileURL: profileURL,
            friends: []
        )
        self.userID = userId
        FirebaseManager.shared.createUser(user: user)
    }

    func verifyURL (urlString: String?) -> Bool {
        guard let urlString = urlString,
              let url = NSURL(string: urlString)
        else { return false }
        return UIApplication.shared.canOpenURL(url as URL)
    }
}
