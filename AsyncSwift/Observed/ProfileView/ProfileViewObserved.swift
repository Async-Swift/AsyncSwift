//
//  ProfileView+Observed.swift
//  AsyncSwift
//
//  Created by Kim Insub on 2022/10/16.
//

import Combine
import UIKit
import CoreImage.CIFilterBuiltins

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

