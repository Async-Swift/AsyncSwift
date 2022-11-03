//
//  UserEntity+CoreDataProperties.swift
//  AsyncSwift
//
//  Created by Kim Insub on 2022/11/03.
//
//

import Foundation
import CoreData


extension UserEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserEntity> {
        return NSFetchRequest<UserEntity>(entityName: "UserEntity")
    }

    @NSManaged public var uuid: String
    @NSManaged public var name: String
    @NSManaged public var nickname: String?
    @NSManaged public var selfDescription: String?
    @NSManaged public var role: String
    @NSManaged public var linkedInURL: String?
    @NSManaged public var profileURL: String?


}

extension UserEntity : Identifiable {

}
