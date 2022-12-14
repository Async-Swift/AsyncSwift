//
//  ProfileView.swift
//  AsyncSwift
//
//  Created by Kim Insub on 2022/10/16.
//

import CodeScanner
import SwiftUI

// TODO
// 1 : Enter 치면 다음 input focused 되도록 변경

struct ProfileView: View {

    @StateObject var observed = ProfileViewObserved()

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                header
                Spacer()
                if observed.hasRegisteredProfile {
                    friendsListLinkButton
                }
                editProfileLinkButton
            }
            .navigationTitle("Profile")
            .navigationBarItems(trailing: codeScannerButton)
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
        }
        .alert("프로필 등록 오류", isPresented: $observed.isShowingFailureAlert, actions: {
            Button("확인", role: .cancel) { observed.isShowingFailureAlert = false }
        }, message: {
            Text("이미 등록된 프로필입니다.")
        })
        .alert("QR 등록 오류", isPresented: $observed.isShowingScanErrorAlert, actions: {
            Button("취소", role: .cancel) { observed.isShowingScanErrorAlert = false }
        }, message: {
            Text("등록할 수 없는 QR코드입니다.")
        })
    }
}

private extension ProfileView {
    @ViewBuilder
    var header: some View {
        if observed.hasRegisteredProfile {
            if observed.isLoading {
                hasRegisteredHeaderLoadingView
            } else {
                hasRegisteredHeader
            }
        } else {
            registerHeader
        }
    }

    var hasRegisteredHeaderLoadingView: some View {
        VStack(spacing: 0) {
            customDivider
                .padding(.top, 10)
                .padding(.bottom, 56)
            Rectangle()
                .frame(width: 130, height:  130)
                .foregroundColor(Color.skeletonQR)
                .padding(.bottom, 26)
            Rectangle()
                .frame(width: 165, height: 23)
                .foregroundColor(Color.skeletonName)
                .cornerRadius(4)
                .padding(.bottom, 7)
            Rectangle()
                .frame(width: 91, height: 16)
                .foregroundColor(Color.skeletonName)
                .cornerRadius(4)
                .padding(.bottom, 25)
            VStack(alignment: .leading, spacing: 0) {
                Rectangle()
                    .frame(width: 309, height: 16)
                    .foregroundColor(Color.skeletonDescription)
                    .cornerRadius(4)
                    .padding(.bottom, 3)
                Rectangle()
                    .frame(width: 309, height: 16)
                    .foregroundColor(Color.skeletonDescription)
                    .cornerRadius(4)
                    .padding(.bottom, 3)
                Rectangle()
                    .frame(width: 221, height: 16)
                    .foregroundColor(Color.skeletonDescription)
                    .cornerRadius(4)
            }
        }
    }

    var hasRegisteredHeader: some View {
        VStack(spacing: 0) {
            customDivider
                .padding(.top, 10)
                .padding(.bottom, 55)
            Image(uiImage: observed.getQRCodeImage())
                .interpolation(.none)
                .resizable()
                .frame(width: 157, height: 157)
                .padding(.bottom, 40)
            Text("\(observed.user.name) | \(observed.user.nickname)")
                .font(.title3)
                .fontWeight(.semibold)
                .padding(.bottom, 4)
            Text("\(observed.user.role)")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.profileGray)
                .padding(.bottom, 18)
            Text("\(observed.user.description)")
                .font(.footnote)
                .padding(.horizontal, 43)
        }
    }

    var registerHeader: some View {
        VStack(spacing: 0) {
            Image("QRplaceholder")
                .frame(width: 157)
                .padding(.bottom, 50)
            Text("등록한 프로필이 없습니다.")
                .foregroundColor(.profileGray)
                .font(.body)
                .padding(.bottom, 17)
            registerLink
        }
        .padding(.top, 68)
    }

    var registerLink: some View {
        NavigationLink {
            ProfileRegisterView(
                hasRegisteredProfile: $observed.hasRegisteredProfile,
                userID: $observed.userID
            )
        } label: {
            Text("프로필 등록하기")
                .font(.headline)
        }
    }

    @ViewBuilder
    var friendsListLinkButton: some View {
        if observed.isLoading {
            Button { } label: {
                linkLabelButtonLabel(text: "Friends")
                    .opacity(0.2)
            }
                .padding(.bottom, 16)
        } else {
            NavigationLink(
                destination: ProfileFriendsListView(
                inActive: $observed.isShowingFriends,
                user: observed.user),
                isActive: $observed.isShowingFriends,
                label: {
                    Button {
                        observed.isShowingFriends = true
                    } label: {
                        linkLabelButtonLabel(text: "Friends")
                    }
                }
            )
                .padding(.bottom, 16)
        }
    }

    @ViewBuilder
    var editProfileLinkButton: some View {
        switch observed.hasRegisteredProfile {
        case true:
            switch observed.isLoading {
            case true:
                Button { } label: {
                    linkLabelButtonLabel(text: "Edit Profile")
                        .opacity(0.2)
                }
                    .padding(.bottom, 32)
            case false:
                NavigationLink(
                    destination: ProfileEditView(user: observed.user),
                    isActive: $observed.isShowingEdit,
                    label: {
                        Button {
                            observed.isShowingEdit = true
                        } label: {
                            linkLabelButtonLabel(text: "Edit Profile")
                        }
                })
                .padding(.bottom, 32)
            }
        case false:
            NavigationLink {
                ProfileRegisterView(
                    hasRegisteredProfile: $observed.hasRegisteredProfile,
                    userID: $observed.userID
                )
            } label: {
                linkLabelButtonLabel(text: "Edit Profile")
            }
            .padding(.bottom, 32)
        }
    }

    @ViewBuilder
    var codeScannerButton: some View {
        if observed.hasRegisteredProfile && !observed.isLoading {
            Button {
                observed.isShowingScanner = true
            } label: {
                Image(systemName: "qrcode.viewfinder")
            }
        } else {
            Button {

            } label: {
                Image(systemName: "qrcode.viewfinder")
                    .foregroundColor(.gray)
            }
        }
    }

    var scannerView: some View {
        VStack {
            ZStack {
                Text("코드스캔")
                HStack {
                    Spacer()
                    Button {
                        observed.didTapCloseButton()
                    } label: {
                        Text("Done")
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

    func linkLabelButtonLabel(text: String) -> some View {
        HStack {
            Text(text)
                .font(.headline)
            Spacer()
            Image(systemName: "chevron.forward")
        }
        .foregroundColor(.black)
        .padding(.horizontal, 19)
        .padding(.vertical, 23)
        .frame(maxWidth: .infinity, maxHeight: 68)
        .background(Color.buttonBackground)
        .cornerRadius(15)
        .padding(.horizontal)
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
