//
//  ProfileFriendDetailView.swift
//  AsyncSwift
//
//  Created by Kim Insub on 2022/11/02.
//

import SwiftUI

struct ProfileFriendDetailView: View {
    @ObservedObject var observed: ProfileFriendDetailViewObserved

    init(
        previous: PreviousView,
        inActive: Binding<Bool>,
        user: User,
        friend: User
    ) {
        observed = ProfileFriendDetailViewObserved(
            inActive: inActive,
            user: user,
            friend: friend,
            previous: previous
        )
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            customDivider
                .padding(.top, 10)
            userDetail
            Spacer()
            linkButtons
        }
        .navigationTitle(observed.friend.name)
        .navigationBarItems(trailing: navigationBarTrailingButton)
        .fullScreenCover(isPresented: $observed.isShowingProfileSheet, content: {
            if let url = observed.profileURL {
                SafariView(url: url)
                    .ignoresSafeArea()
            }
        })
        .fullScreenCover(isPresented: $observed.isShowingLinkedInSheet, content: {
            if let url = observed.linkedInURL {
                SafariView(url: url)
                    .ignoresSafeArea()
            }
        })
        .alert(isPresented: $observed.isShowingConfirmAlert) {
            Alert(
                title: Text("삭제"),
                message: Text("유저 친구 목록에서 삭제하시겠습니까?"),
                primaryButton: .destructive(Text("삭제")) {
                    observed.didConfirmDelete()
                },
                secondaryButton: .cancel(Text("취소")) {
                    observed.isShowingConfirmAlert = false
                }
            )
        }
    }
}

private extension ProfileFriendDetailView {
    var userDetail: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(observed.friend.nickname)
                .fontWeight(.semibold)
                .font(.system(size: 20))
            Text(observed.friend.role)
                .fontWeight(.semibold)
                .font(.system(size: 20))
                .foregroundColor(.profileFontGrayForeground)
                .padding(.bottom, 24)
            Text(observed.friend.description)
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
            if observed.hasProfileURL {
                observed.isShowingProfileSheet = true
            }
        } label: {
            Text("Profile URL")
                .font(.headline)
                .foregroundColor(.white)
                .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 68)
                .background(observed.hasProfileURL ? Color.seminarOrange : Color.inActiveButtonBackground)
                .cornerRadius(15)
        }
    }

    var linkedInButton: some View {
        Button {
            if observed.hasLinkedInURL {
                observed.isShowingLinkedInSheet = true
            }
        } label: {
            Text("LinkedIn")
                .font(.headline)
                .foregroundColor(.white)
                .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 68)
                .background(observed.hasLinkedInURL ? Color.linkedInBlueBackground : Color.inActiveButtonBackground)
                .cornerRadius(15)
        }
    }

    @ViewBuilder
    var navigationBarTrailingButton: some View {
        switch observed.previous {
        case .ProfileView:
            doneButton
        case .ListView:
            deleteButton
        }
    }

    var doneButton: some View {
        Button {
            observed.didTapDoneButton()
        } label: {
            Text("Done")
        }
    }

    var deleteButton: some View {
        Button {
            observed.didTapDeleteButton()
        } label: {
            Text("Delete")
        }
    }
}
