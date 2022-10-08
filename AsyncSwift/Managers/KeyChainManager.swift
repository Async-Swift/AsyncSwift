//
//  KeyChain.swift
//  AsyncSwift
//
//  Created by Inho Choi on 2022/09/15.
//

import Foundation
import UIKit

final class KeyChainManager {
    let stampKey = "AsyncSwiftStamp"
    
    @discardableResult func addItem(key: Any, pwd: Any) -> Bool {
        let addQuery: [CFString: Any] = [kSecClass: kSecClassGenericPassword,
                                         kSecAttrAccount: key,
                                         kSecValueData: (pwd as AnyObject).data(using: String.Encoding.utf8.rawValue) as Any]

        let status = SecItemAdd(addQuery as CFDictionary, nil)

        switch status {
        case errSecSuccess:
            return true
        case errSecDuplicateItem:
            return updateItem(value: pwd, key: key)
        default:
            print("addItem Error : \(status.description))")
            return false
        }
    }

    func getItem(key: Any) -> Any? {
        let getQuery: [CFString: Any] = [kSecClass: kSecClassGenericPassword,
                                         kSecAttrAccount: key,
                                         kSecReturnAttributes: true,
                                         kSecReturnData: true]
        var item: CFTypeRef?
        let result = SecItemCopyMatching(getQuery as CFDictionary, &item)

        if result == errSecSuccess,
            let existingItem = item as? [String: Any],
            let data = existingItem[kSecValueData as String] as? Data,
            let password = String(data: data, encoding: .utf8) {
            return password
        }
        print("getItem Error : \(result.description)")
        return nil
    }

    func updateItem(value: Any, key: Any) -> Bool {
        let prevQuery: [CFString: Any] = [kSecClass: kSecClassGenericPassword,
                                          kSecAttrAccount: key]
        let updateQuery: [CFString: Any] = [kSecValueData: (value as AnyObject).data(using: String.Encoding.utf8.rawValue) as Any]

        let result: Bool = {
            let status = SecItemUpdate(prevQuery as CFDictionary, updateQuery as CFDictionary)
            return status == errSecSuccess
        }()

        return result
    }

    func deleteItem(key: String) -> Bool {
        let deleteQuery: [CFString: Any] = [kSecClass: kSecClassGenericPassword,
                                            kSecAttrAccount: key]
        let status = SecItemDelete(deleteQuery as CFDictionary)
        if status == errSecSuccess {
            return true
        } else {
            print("deleteItem Error : \(status.description)")
            return false
        }
    }
}
