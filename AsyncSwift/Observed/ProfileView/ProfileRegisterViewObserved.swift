//
//  ProfileRegisterViewObserved.swift
//  AsyncSwift
//
//  Created by Kim Insub on 2022/10/28.
//

import Combine
import SwiftUI

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
        if isButtonAvailable() {
            // 입력이 비어있지 않다면
            if !linkedInURL.isEmpty && !profileURL.isEmpty {
                // 검사를 한다
                if isLinkedinURLValidated && isProfileURLValidated {
                    // 검사 통과시 통과
                    Task {
                        await createUser()
                        DispatchQueue.main.async { [weak self] in
                            guard let self = self else { return }
                            self.isShowingSuccessAlert = true
                            self.hasRegisteredProfile = true
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
                        await createUser()
                        DispatchQueue.main.async { [weak self] in
                            guard let self = self else { return }
                            self.isShowingSuccessAlert = true
                            self.hasRegisteredProfile = true
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
                        await createUser()
                        DispatchQueue.main.async { [weak self] in
                            guard let self = self else { return }
                            self.isShowingSuccessAlert = true
                            self.hasRegisteredProfile = true
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
                    await createUser()
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        self.isShowingSuccessAlert = true
                        self.hasRegisteredProfile = true
                    }
                }
            }
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
            profileURL: profileURL
        )
        self.userID = userId
        FirebaseManager.shared.createUser(user: user)
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
