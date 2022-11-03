//
//  ProfileFriendsListView.swift
//  AsyncSwift
//
//  Created by Kim Insub on 2022/11/02.
//

import SwiftUI

struct ProfileFriendsListView: View {

    @ObservedObject var observed = ProfileFriendsListViewObserved()

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
        ForEach(friends, id: \.self) { friend in
            ProfileViewButton(
                title: "\(friend.name) | \(friend.nickname)",
                linkTo: AnyView(ProfileFriendDetailView(user: friend))
            )
            .padding(.bottom, 20)
        }
    }
}

let friends = [
    Friend(
        name: "Siwon Song",
        nickname: "SongCool",
        role: "Tech Mentor",
        description: "안녕하세요 AsyncSwift Korea Organizer 입니다.\nApple Developver Academy @POSTECH 에서 테크멘토로 일하고 있고 저는 코드리뷰에 진심이며 일본을 사랑합니다. 와따시",
        profileURL: "www.naver.com",
        linkedInURL: "www.youtube.com"
    ),
    Friend(
        name: "Siwon Song",
        nickname: "SongCool",
        role: "Tech Mentor",
        description: "안녕하세요 AsyncSwift Korea Organizer 입니다.\nApple Developver Academy @POSTECH 에서 테크멘토로 일하고 있고 저는 코드리뷰에 진심이며 일본을 사랑합니다. 와따시",
        profileURL: "www.naver.com",
        linkedInURL: "www.youtube.com"
    ),
    Friend(
        name: "Siwon Song",
        nickname: "SongCool",
        role: "Tech Mentor",
        description: "안녕하세요 AsyncSwift Korea Organizer 입니다.\nApple Developver Academy @POSTECH 에서 테크멘토로 일하고 있고 저는 코드리뷰에 진심이며 일본을 사랑합니다. 와따시",
        profileURL: "www.naver.com",
        linkedInURL: "www.youtube.com"
    )
]

struct Friend: Hashable {
    let name: String
    let nickname: String
    let role: String
    let description: String
    let profileURL: String
    let linkedInURL: String
}
