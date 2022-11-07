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
        let docData: [String: Any] = [
            "id": user.id,
            "name": user.name,
            "nickname": user.nickname,
            "role": user.role,
            "description": user.description,
            "linkedInURL": user.linkedInURL,
            "profileURL": user.profileURL,
            "friends": []
        ]
        docRef.setData(docData) { error in
            if let error = error {
                print("Error writing document: \(error)")
            } else {
                print("Document successfully written")
            }
        }
    }

    func getUserBy(id: String, completion: @escaping (User) -> Void) {
        let docRef = db.collection("users").document(id)
        docRef.getDocument { (document, error) in
            guard error == nil,
                  let document = document,
                  document.exists,
                  let data = document.data(),
                  let id = data["id"] as? String,
                  let name = data["name"] as? String,
                  let nickname = data["nickname"] as? String,
                  let role = data["role"] as? String,
                  let description = data["description"] as? String,
                  let linkedInURL = data["linkedInURL"] as? String,
                  let profileURL = data["profileURL"] as? String,
                  let friends = data["friends"] as? [String]
            else { return }

            let user = User(
                id: id,
                name: name,
                nickname: nickname,
                role: role,
                description: description,
                linkedInURL: linkedInURL,
                profileURL: profileURL,
                friends: friends
            )
            completion(user)
        }
    }

    func editUser(user: User) {
        let docRef = db.collection("users").document(user.id)
        let docData: [String: Any] = [
            "id": user.id,
            "name": user.name,
            "nickname": user.nickname,
            "role": user.role,
            "description": user.description,
            "linkedInURL": user.linkedInURL,
            "profileURL": user.profileURL,
            "friends": user.friends
        ]

        docRef.setData(docData) { error in
            if let error = error {
                print("Error writing document: \(error)")
            } else {
                print("Document successfully editted")
            }
        }
    }
}
