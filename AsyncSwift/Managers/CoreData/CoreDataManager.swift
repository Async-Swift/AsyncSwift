//
//  CoreDataManager.swift
//  AsyncSwift
//
//  Created by Kim Insub on 2022/11/03.
//

import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()

    private let databaseName = "DataModel.sqlite"
    private let container = NSPersistentCloudKitContainer(name: "DataModel")
    private var context: NSManagedObjectContext {
        container.viewContext
    }

    private init() {
        loadStores()
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
}

private extension CoreDataManager {
    func loadStores() {
        container.loadPersistentStores { desc, error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}

extension CoreDataManager {
    func save() {
        do {
            try context.save()
        } catch {
            print("FAILED TO SAVE CONTEXT")
        }
    }

    func createUser(
        name: String,
        nickname: String?,
        selfDescription: String?,
        role: String,
        linkedInURL: String?,
        profileURL: String?
    ) {
        let user = UserEntity(context: context)
        user.uuid = UUID().uuidString
        user.name = name
        user.nickname = nickname
        user.selfDescription = selfDescription
        user.role = role
        user.linkedInURL = linkedInURL
        user.profileURL = profileURL
        save()
    }
}
