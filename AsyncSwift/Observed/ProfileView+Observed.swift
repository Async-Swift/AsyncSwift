//
//  ProfileView+Observed.swift
//  AsyncSwift
//
//  Created by Kim Insub on 2022/10/16.
//

import Foundation
import Combine

final class ProfileViewObserved: ObservableObject {
    @Published var hasRegisterProfile = UserDefaults.standard.bool(forKey: "hasRegisterProfile") {
        didSet {
            UserDefaults.standard.set(hasRegisterProfile, forKey: "hasRegisterProfile")
        }
    }

    @Published var isShowingSuccessAlert = false
    @Published var isShowingFailureAlert = false

    @Published var name = ""
    @Published var nickname = ""
    @Published var jobTitle = ""
    @Published var linkedinURL = ""
    @Published var privateURL = ""

    func didTapRegisterButton() {
        if !name.isEmpty && !jobTitle.isEmpty {
            print("okay")
        }
    }
}
