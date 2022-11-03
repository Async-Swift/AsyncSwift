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
    @Published var isShowingSuccessAlert = false
    @Published var isShowingFailureAlert = false
    @Published var isShowingInputFailureAlert = false

    @Published var name = ""
    @Published var nickname = ""
    @Published var role = ""
    @Published var selfDescription = "" {
        didSet {
            if selfDescription.count >= 80 {
                selfDescription = oldValue
            }
        }
    }
    @Published var linkedInURL = "" {
        didSet {
            self.isLinkedinURLValidated = self.verifyUrl(urlString: linkedInURL)
        }
    }
    @Published var profileURL = "" {
        didSet {
            self.isPrivateURLValidated = self.verifyUrl(urlString: profileURL)
        }
    }
    var isLinkedinURLValidated = false
    var isPrivateURLValidated = false

    init(hasRegisteredProfile: Binding<Bool>) {
        self._hasRegisteredProfile = hasRegisteredProfile
    }

    func didTapRegisterButton() {
        if isButtonAvailable() {
            // 입력이 비어있지 않다면
            if !linkedInURL.isEmpty && !profileURL.isEmpty {
                // 검사를 한다
                if isLinkedinURLValidated && isPrivateURLValidated {
                    // 검사 통과시 통과
                    Task {
                        await createUser()
//                        isShowingSuccessAlert = true
//                        hasRegisteredProfile = true
                    }
                } else {
                    // 검사 실패시 엘러트
                    isShowingInputFailureAlert = true
                }
            // 입력이 비어있지 않다면
            } else if !linkedInURL.isEmpty {
                if isLinkedinURLValidated {
                    // 검사 통과시 통과
                    Task {
                        await createUser()
//                        isShowingSuccessAlert = true
//                        hasRegisteredProfile = true
                    }
                } else {
                    // 검사 실패시 엘러트
                    isShowingInputFailureAlert = true
                }
            // 입력이 비어있지 않다면
            } else if !profileURL.isEmpty {
                // 검사를 한다
                if isPrivateURLValidated {
                    // 검사 통과시 통과
                    Task {
                        await createUser()
//                        isShowingSuccessAlert = true
//                        hasRegisteredProfile = true
                    }
                } else {
                    // 검사 실패시 엘러트
                    isShowingInputFailureAlert = true
                }
            } else {
                // 입력이 비어있다면 통과
                Task {
                    await createUser()
//                        isShowingSuccessAlert = true
//                        hasRegisteredProfile = true
                }
            }
        }
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
    func createUser() async {
        
    }

    func verifyUrl (urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url = NSURL(string: urlString) {
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }
}
