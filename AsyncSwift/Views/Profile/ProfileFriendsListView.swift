//
//  ProfileFriendsListView.swift
//  AsyncSwift
//
//  Created by Kim Insub on 2022/11/02.
//

import SwiftUI
import CodeScanner

struct ProfileFriendsListView: View {
    @StateObject var observed: ProfileFriendsListViewObserved

    init(inActive: Binding<Bool>, user: User) {
        _observed = StateObject(
            wrappedValue: ProfileFriendsListViewObserved(
            inActive: inActive,
            user: user
        ))
    }

    var body: some View {
        VStack(spacing: 0) {
            customDivider
                .padding(.top, 10)
            friendList
        }
        .navigationTitle("Friends")
        .fullScreenCover(
            isPresented: $observed.isShowingScanner,
            content: { scannerView }
        )
        .fullScreenCover(
            isPresented: $observed.isShowingUserDetail,
            content: { scannedFriendDetail }
        )
        .onAppear {
            observed.onAppear()
        }
        .alert("QR 등록 오류", isPresented: $observed.isShowingScanErrorAlert, actions: {
            Button("취소", role: .cancel) { observed.isShowingScanErrorAlert = false }
        }, message: {
            Text("등록할 수 없는 QR코드입니다.")
        })
    }
}

private extension ProfileFriendsListView {
    @ViewBuilder
    var friendList: some View {
        switch observed.isLoading {
        case true:
            loadingList
        case false:
            switch observed.user.friends.isEmpty {
            case true:
                emptyList
            case false:
                ScrollView {
                    list
                    .padding(.top, 30)
                }
            }
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
                .foregroundColor(Color.inActiveButtonBackground)
                .cornerRadius(15)
                .padding(.bottom, 20)
        }
        .padding(.horizontal)
    }

    var list: some View {
        ForEach(observed.friendsList) { friend in
            listCell(friend: friend)
                .padding(.bottom, 20)
        }
        .padding(.horizontal)
    }

    func listCell(friend: User) -> some View {
        NavigationLink {
            ProfileFriendDetailView(
                previous: .ListView,
                inActive: $observed.inActive,
                user: observed.user,
                friend: friend
            )
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
                        Text("Done")
                    }
                    .padding()
                }
            }
            .frame(height: 51)
            CodeScannerView(
                codeTypes: [.qr],
                simulatedData: "6A8254C2-1054-4A5B-9F30-602684D329F9",
                completion: observed.handleScan
            )
            HStack {
                Text("QR코드를 스캔해 보세요. 프로필 상세 정보를 확인할 수 있습니다.")
                    .font(.caption2)
            }
            .frame(height: 70)
        }
    }

    var scannedFriendDetail: some View {
        NavigationView {
            VStack {
                ProfileFriendDetailView(
                    previous: .ProfileView,
                    inActive: $observed.isShowingUserDetail,
                    user: observed.user,
                    friend: observed.scannedFriend
                )
            }
        }
    }
}
