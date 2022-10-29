//
//  ProfileView.swift
//  AsyncSwift
//
//  Created by Kim Insub on 2022/10/16.
//

import SwiftUI


// TODO
// 1 : Enter 치면 다음 input focused 되도록 변경

struct ProfileView: View {

    @ObservedObject var observed: ProfileViewObserved

    init() {
        observed = ProfileViewObserved()
    }

    var body: some View {
        NavigationView {
            NavigationLink {
                ProfileRegisterView(hasRegisteredProfile: $observed.hasRegisteredProfile)
            } label: {
                Text("프로필 등록하기")
            }
        }
    }
}
