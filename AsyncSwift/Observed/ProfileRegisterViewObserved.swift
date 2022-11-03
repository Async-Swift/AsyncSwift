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
    @Published var jobTitle = ""
    @Published var introduction = "" {
        didSet {
            if introduction.count >= 80 {
                introduction = oldValue
            }
        }
    }
    @Published var linkedinURL = "" {
        didSet {
            self.isLinkedinURLValidated = self.verifyUrl(urlString: linkedinURL)
        }
    }
    @Published var privateURL = "" {
        didSet {
            self.isPrivateURLValidated = self.verifyUrl(urlString: privateURL)
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
            if !linkedinURL.isEmpty && !privateURL.isEmpty {
                // 검사를 한다
                if isLinkedinURLValidated && isPrivateURLValidated {
                    // 검사 통과시 통과
                    isShowingSuccessAlert = true
                    hasRegisteredProfile = true
                } else {
                    // 검사 실패시 엘러트
                    isShowingInputFailureAlert = true
                }
            // 입력이 비어있지 않다면
            } else if !linkedinURL.isEmpty {
                if isLinkedinURLValidated {
                    // 검사 통과시 통과
                    isShowingSuccessAlert = true
                    hasRegisteredProfile = true
                } else {
                    // 검사 실패시 엘러트
                    isShowingInputFailureAlert = true
                }
            // 입력이 비어있지 않다면
            } else if !privateURL.isEmpty {
                // 검사를 한다
                if isPrivateURLValidated {
                    // 검사 통과시 통과
                    isShowingSuccessAlert = true
                    hasRegisteredProfile = true
                } else {
                    // 검사 실패시 엘러트
                    isShowingInputFailureAlert = true
                }
            } else {
                // 입력이 비어있다면 통과
                isShowingSuccessAlert = true
                hasRegisteredProfile = true
            }
        }
    }

    func isButtonAvailable() -> Bool {
        if !name.isEmpty && !jobTitle.isEmpty {
            return true
        } else {
            return false
        }
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
