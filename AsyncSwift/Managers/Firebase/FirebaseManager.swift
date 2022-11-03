//
//  FirebaseManager.swift
//  AsyncSwift
//
//  Created by Kim Insub on 2022/11/03.
//

import Firebase
import Foundation

final class FirebaseManager: ObservableObject {
    static let shared = FirebaseManager()
    let db = Firestore.firestore()
    private init() { }
}

extension FirebaseManager {
    func createUser(user: User) {
        let docRef = db.collection("users").document(user.id)
        docRef.setData([
            "id": user.id,
            "name": user.name,
            "nickname": user.nickname,
            "role": user.role,
            "description": user.description,
            "linkedInURL": user.linkedInURL,
            "profileURL": user.profileURL
        ]) { error in
            if let error = error {
                print("Error writing document: \(error)")
            } else {
                print("Document successfully written!")
            }
        }
    }

    func getUserBy(id: String, completion: @escaping (User) -> Void) {
        let docRef = db.collection("users").document(id)
        docRef.getDocument { (document, error) in
            guard error == nil else { return }

            if let document = document, document.exists {
                let data = document.data()
                if let data = data {
                    let user = User(
                        id: data["id"] as? String ?? "",
                        name: data["name"] as? String ?? "",
                        nickname: data["nickname"] as? String ?? "",
                        role: data["role"] as? String ?? "",
                        description: data["description"] as? String ?? "",
                        linkedInURL: data["linkedInURL"] as? String ?? "",
                        profileURL: data["profileURL"] as? String ?? ""
                    )
                    completion(user)
                }
            }
        }
    }

    func editUser(user: User) {
        let docRef = db.collection("users").document(user.id)

        docRef.setData([
            "id": user.id,
            "name": user.name,
            "nickname": user.nickname,
            "role": user.role,
            "description": user.description,
            "linkedInURL": user.linkedInURL,
            "profileURL": user.profileURL],
            merge: true
        ) { error in
            if let error = error {
                print("Error writing document: \(error)")
            } else {
                print("Document successfully merged!")
            }
        }
    }
}
