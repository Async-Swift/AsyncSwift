//
//  ProfileFriendsListView.swift
//  AsyncSwift
//
//  Created by Kim Insub on 2022/11/02.
//

import SwiftUI
import CodeScanner

struct ProfileFriendsListView: View {

    @ObservedObject var observed: ProfileFriendsListViewObserved

    init(inActive: Binding<Bool>, user: User) {
        observed = ProfileFriendsListViewObserved(
            inActive: inActive,
            user: user
        )
    }

    var body: some View {
        VStack(spacing: 0) {
            customDivider
                .padding(.top, 10)
                .padding(.bottom, 30)
            friendList
            Spacer()
        }
        .navigationTitle("Friends")
        .onAppear {
            observed.onAppear()
        }
        .fullScreenCover(isPresented: $observed.isShowingScanner, content: {
            scannerView
        })
    }
}

private extension ProfileFriendsListView {
    @ViewBuilder
    var friendList: some View {
        if observed.user.friends.isEmpty {
            emptyList
        } else if observed.isLoading {
            loadingList
        } else {
            list
        }
    }

    var emptyList: some View {
        VStack(spacing: 0) {
            Spacer()
            Text("등록된 프로필이 없습니다.")
                .foregroundColor(.profileGray)
                .padding(.bottom, 17)
            Button {
                observed.isShowingScanner = true
            } label: {
                Text("프로필 스캔하기")
                    .foregroundColor(.seminarOrange)
                    .font(.headline)
            }
            Spacer()
        }
    }

    var loadingList: some View {
        ForEach(0..<observed.user.friends.count, id: \.self) { friend in
            Rectangle()
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 56)
                .foregroundColor(Color.inActiveButton)
                .cornerRadius(15)
        }
        .padding(.horizontal)
    }

    var list: some View {
        ForEach(observed.friendsList) { friend in
            listCell(friend: friend)
        }
        .padding(.horizontal)
    }

    func listCell(friend: User) -> some View {
        NavigationLink {
            ProfileFriendDetailView(user: friend)
        } label: {
            HStack {
                Text("\(friend.name) | \(friend.nickname)")
                    .font(.headline)
                Spacer()
                Image(systemName: "chevron.forward")
            }
            .foregroundColor(.black)
            .padding(.horizontal, 19)
            .padding(.vertical, 23)
            .frame(maxWidth: .infinity, maxHeight: 56)
            .background(Color.buttonBackground)
            .cornerRadius(15)
        }
    }

    var scannerView: some View {
        VStack {
            ZStack {
                Text("코드스캔")
                HStack {
                    Spacer()
                    Button {
                        observed.didTapXButton()
                    } label: {
                        Image(systemName: "xmark")
                    }
                    .padding()
                }
            }
            .frame(height: 51)
            CodeScannerView(
                codeTypes: [.qr],
                simulatedData: "1AA5CC09-6F7F-4EC4-A2BE-819B93362B7B",
                completion: observed.handleScan
            )
            HStack {
                Text("QR코드를 스캔해 보세요. 프로필 상세 정보를 확인할 수 있습니다.")
                    .font(.caption2)
            }
            .frame(height: 70)
        }
    }
}
