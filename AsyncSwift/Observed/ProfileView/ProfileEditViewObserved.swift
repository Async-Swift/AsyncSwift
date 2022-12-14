//
//  ProfileEditViewObserved.swift
//  AsyncSwift
//
//  Created by Kim Insub on 2022/11/04.
//

import UIKit

@MainActor
final class ProfileEditViewObserved: ObservableObject {

    @Published var isShowingSuccessAlert = false
    @Published var isShowingFailureAlert = false
    @Published var isShowingInputFailureAlert = false

    @Published var user: User
    @Published var description = "" {
        didSet {
            if description.count >= 80 {
                description = oldValue
            }
        }
    }
    @Published var linkedInURL = "" {
        didSet {
            print(self.verifyURL(urlString: profileURL))
            self.isLinkedinURLValidated = self.verifyURL(urlString: linkedInURL)
        }
    }
    @Published var profileURL = "" {
        didSet {
            print(self.verifyURL(urlString: profileURL))
            self.isProfileURLValidated = self.verifyURL(urlString: profileURL)
        }
    }
    var isLinkedinURLValidated = true
    var isProfileURLValidated = true

    init(user: User) {
        self.description = user.description
        self.linkedInURL = user.linkedInURL
        self.profileURL = user.profileURL
        self.user = user
    }

    func didTapRegisterButton() {
        register()
    }

    func isButtonAvailable() -> Bool {
        !user.name.isEmpty && !user.role.isEmpty
    }
}

private extension ProfileEditViewObserved {
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
            await editUser()
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

    func editUser() async {
        let user = User(
            id: user.id,
            name: user.name,
            nickname: user.nickname,
            role: user.role,
            description: description,
            linkedInURL: linkedInURL,
            profileURL: profileURL,
            friends: user.friends
        )
        FirebaseManager.shared.editUser(user: user)
    }

    func verifyURL (urlString: String?) -> Bool {
        guard let urlString = urlString,
              let url = NSURL(string: urlString)
        else { return false }
        return UIApplication.shared.canOpenURL(url as URL)
    }
}
