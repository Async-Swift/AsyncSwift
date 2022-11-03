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
}

