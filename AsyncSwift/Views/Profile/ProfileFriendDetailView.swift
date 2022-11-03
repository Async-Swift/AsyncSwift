//
//  ProfileFriendDetailView.swift
//  AsyncSwift
//
//  Created by Kim Insub on 2022/11/02.
//

import SwiftUI

struct ProfileFriendDetailView: View {

    let user: Friend
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            customDivider
                .padding(.top, 10)
            userDetail
            Spacer()
            linkButtons
        }
        .navigationTitle(user.name)
    }
}

private extension ProfileFriendDetailView {

    var userDetail: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(user.nickname)
                .fontWeight(.semibold)
                .font(.system(size: 20))
            Text(user.role)
                .fontWeight(.semibold)
                .font(.system(size: 20))
                .foregroundColor(.profileFontGray)
                .padding(.bottom, 24)
            Text(user.description)
        }
        .padding(.horizontal, 24)
        .padding(.top, 28)
    }

    var linkButtons: some View {
        VStack {
            urlLinkButton
            urlLinkButton
                .padding(.bottom, 16)
        }
        .padding(.horizontal)
    }

    var urlLinkButton: some View {
        Text("LinkedIn")
            .font(.headline)
            .foregroundColor(.white)
            .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 68)
            .background(Color.seminarOrange)
            .cornerRadius(15)
    }
}
