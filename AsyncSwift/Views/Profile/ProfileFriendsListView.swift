//
//  ProfileFriendsListView.swift
//  AsyncSwift
//
//  Created by Kim Insub on 2022/11/02.
//

import SwiftUI

struct ProfileFriendsListView: View {

    @ObservedObject var observed: ProfileFriendsListViewObserved

    init(friends: [String]) {
        observed = ProfileFriendsListViewObserved(friends: friends)
    }

    var body: some View {
        VStack(spacing: 0) {
            customDivider
                .padding(.top, 10)
                .padding(.bottom, 28)
            friendList
            Spacer()
        }
        .navigationTitle("Friends")
        .onAppear {
            observed.onAppear()
        }
    }
}

private extension ProfileFriendsListView {
    var friendList: some View {
        ForEach(observed.friendsList) { friend in
            ProfileViewButton(
                title: "\(friend.name) | \(friend.nickname)",
                linkTo: AnyView(ProfileFriendDetailView(user: friend))
            )
            .padding(.bottom, 20)
        }
    }
}
