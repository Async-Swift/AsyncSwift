//
//  AppData.swift
//  AsyncSwift
//
//  Created by Inho Choi on 2022/09/08.
//

import SwiftUI

extension MainTabView {
    final class Observed: ObservableObject {
        /// Universal Link로 앱진입시 StampView 전환을 위한 변수
        @Published var currentTab: Tab = .event
        private let keyChainManager = KeyChainManager()
        
        init() {
            fixKeyChain()
        }
        
        
        // MARK: 버전 1의 실수를 바로 잡습니다. @Toby
        /// "seminar002"가 key로 들어가 있던 기존 코드를 삭제하는 함수입니다.
        /// - KeyChain에 저장되는 방식을 개선하고자 함수가 구현되었습니다.
        func fixKeyChain() {
            let isKeyDelete = keyChainManager.deleteItem(key: "seminar002")
            if isKeyDelete {
                keyChainManager.addItem(key: keyChainManager.stampKey, pwd: ["Seminar002"].description)
            }
        }
    }
}
