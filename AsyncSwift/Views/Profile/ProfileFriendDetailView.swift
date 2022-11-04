//
//  ProfileFriendDetailView.swift
//  AsyncSwift
//
//  Created by Kim Insub on 2022/11/02.
//

import SwiftUI

struct ProfileFriendDetailView: View {

    @ObservedObject var observed: ProfileFriendDetailViewObserved

    init(user: User) {
        observed = ProfileFriendDetailViewObserved(user: user)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            customDivider
                .padding(.top, 10)
            userDetail
            Spacer()
            linkButtons
        }
        .navigationTitle(observed.user.name)
        .fullScreenCover(isPresented: $observed.isShowingProfileSheet, content: {
            SafariView(url: observed.user.profileURL)
                .ignoresSafeArea()
        })
        .fullScreenCover(isPresented: $observed.isShowingLinkedInSheet, content: {
            SafariView(url: observed.user.linkedInURL)
                .ignoresSafeArea()
        })
    }
}

private extension ProfileFriendDetailView {

    var userDetail: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(observed.user.nickname)
                .fontWeight(.semibold)
                .font(.system(size: 20))
            Text(observed.user.role)
                .fontWeight(.semibold)
                .font(.system(size: 20))
                .foregroundColor(.profileFontGray)
                .padding(.bottom, 24)
            Text(observed.user.description)
        }
        .padding(.horizontal, 24)
        .padding(.top, 28)
    }

    var linkButtons: some View {
        VStack {
            profileButton
            linkedInButton
                .padding(.bottom, 16)
        }
        .padding(.horizontal)
    }

    var profileButton: some View {
        Button {
            if observed.hasProfileURL() {
                observed.isShowingProfileSheet = true
            }
        } label: {
            Text("Profile URL")
                .font(.headline)
                .foregroundColor(.white)
                .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 68)
                .background(observed.hasProfileURL() ? Color.seminarOrange : Color.inActiveButton)
                .cornerRadius(15)
        }
    }

    var linkedInButton: some View {
        Button {
            if observed.hasLinkedInURL() {
                observed.isShowingLinkedInSheet = true
            }
        } label: {
            Text("LinkedIn")
                .font(.headline)
                .foregroundColor(.white)
                .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 68)
                .background(observed.hasLinkedInURL() ? Color.linkedInBlue : Color.inActiveButton)
                .cornerRadius(15)
        }
    }
}
