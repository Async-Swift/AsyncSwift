//
//  ProfileView+Observed.swift
//  AsyncSwift
//
//  Created by Kim Insub on 2022/10/16.
//

import Combine
import UIKit

final class ProfileViewObserved: ObservableObject {
    @Published var hasRegisteredProfile = UserDefaults.standard.bool(forKey: "hasRegisterProfile") {
        didSet {
            UserDefaults.standard.set(hasRegisteredProfile, forKey: "hasRegisterProfile")
        }
    }

    @Published var user: User = User(id: "", name: "", nickname: "", role: "", description: "", linkedInURL: "", profileURL: "")

    var userID = UserDefaults.standard.string(forKey: "userID") {
        didSet {
            UserDefaults.standard.set(userID, forKey: "userID")
        }
    }

    func onAppear() {
        if hasRegisteredProfile {
            getUserByID()
        }
    }
}

private extension ProfileViewObserved {
    func getUserByID() {
        FirebaseManager.shared.getUserBy(id: self.userID ?? "") { user in
            print(user)
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.user = user
            }
        }
    }
}

