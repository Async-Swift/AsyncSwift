//
//  Any+.swift
//  AsyncSwift
//
//  Created by Inho Choi on 2022/10/07.
//

import Foundation

extension String {
    func convertToStringArray() -> [String]? {
        guard let stringData = self.data(using: .utf8) else {
            return nil
        }
        
        var result = [String]()
        do {
            result = try JSONDecoder().decode([String].self, from: stringData)
        } catch {
            return nil
        }
        return result
    }
}
