//
//  ProfileEditViewObserved.swift
//  AsyncSwift
//
//  Created by Kim Insub on 2022/11/04.
//

import Foundation
import UIKit

final class ProfileEditViewObserved: ObservableObject {

    @Published var isShowingSuccessAlert = false
    @Published var isShowingFailureAlert = false
    @Published var isShowingInputFailureAlert = false

    let user: User
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

    init(user: User) {
        self.user = user
        self.name = user.name
        self.nickname = user.nickname
        self.role = user.role
        self.description = user.description
        self.linkedInURL = user.linkedInURL
        self.profileURL = user.profileURL
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

private extension ProfileEditViewObserved {
    func register() {
        guard isButtonAvailable() else { return }
        // 입력이 비어있지 않다면
        if !linkedInURL.isEmpty && !profileURL.isEmpty {
            // 검사를 한다
            if isLinkedinURLValidated && isProfileURLValidated {
                // 검사 통과시 통과
                Task {
                    await editUser()
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        self.isShowingSuccessAlert = true
                    }
                }
            } else {
                // 검사 실패시 엘러트
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.isShowingInputFailureAlert = true
                }
            }
        // 입력이 비어있지 않다면
        } else if !linkedInURL.isEmpty {
            if isLinkedinURLValidated {
                // 검사 통과시 통과
                Task {
                    await editUser()
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        self.isShowingSuccessAlert = true
                    }
                }
            } else {
                // 검사 실패시 엘러트
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.isShowingInputFailureAlert = true
                }
            }
        // 입력이 비어있지 않다면
        } else if !profileURL.isEmpty {
            // 검사를 한다
            if isProfileURLValidated {
                // 검사 통과시 통과
                Task {
                    await editUser()
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        self.isShowingSuccessAlert = true
                    }
                }
            } else {
                // 검사 실패시 엘러트
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.isShowingInputFailureAlert = true
                }
            }
        } else {
            // 입력이 비어있다면 통과
            Task {
                await editUser()
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.isShowingSuccessAlert = true
                }
            }
        }
    }

    func editUser() async {
        let user = User(
            id: user.id,
            name: name,
            nickname: nickname,
            role: role,
            description: description,
            linkedInURL: linkedInURL,
            profileURL: profileURL,
            friends: user.friends
        )
        FirebaseManager.shared.editUser(user: user)
    }

    func verifyURL (urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url = NSURL(string: urlString) {
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }
}
