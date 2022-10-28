//
//  ProfileRegisterView.swift
//  AsyncSwift
//
//  Created by Kim Insub on 2022/10/28.
//

import SwiftUI

struct ProfileRegisterView: View {

    @ObservedObject var observed: ProfileRegisterViewObserved

    init(hasRegisteredProfile: Binding<Bool>) {
        observed = ProfileRegisterViewObserved(hasRegisteredProfile: hasRegisteredProfile)
    }

    var body: some View {
        VStack(spacing: 0) {
            Header
            ScrollView {
                VStack(spacing: 0) {
                    nameInput
                    nicknameInput
                    jobTitleInput
                    linkedinInput
                    privateURL
                }
            }
            Spacer()
        }
        .navigationTitle("Profile")
        .toolbar {
            Button {
                observed.didTapRegisterButton()
            } label: {
                Text("Save")
            }
        }
        .alert("프로필 등록 완료", isPresented: $observed.isShowingSuccessAlert, actions: {
            Button("확인", role: .cancel) { }
        }, message: {
            Text("개인 프로필이 추가되었습니다.")
        })
        .alert("프로필 등록 오류", isPresented: $observed.isShowingFailureAlert, actions: {
            Button("다시 시도", role: .cancel) { }
        }, message: {
            Text("입력되지 않은 내용이 있습니다.\n필수 입력란을 확인해주세요.")
        })
        .alert("프로필 입력 오류", isPresented: $observed.isShowingInputFailureAlert, actions: {
            Button("다시 시도", role: .cancel) { }
        }, message: {
            Text("확인되지 않은 주소입니다.\nURL을 확인해주세요.")
        })
    }
}

private extension ProfileRegisterView {
    var Header: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    Text("프로필을 등록해주세요")
                        .font(.title3)
                        .fontWeight(.bold)
                        .frame(minHeight: 24)
                        .padding(.bottom, 3)
                    Spacer()
                }
                HStack(spacing: 0) {
                    Text("특수문자는 입력할 수 없어요")
                        .font(.footnote)
                        .frame(minHeight: 18)
                    Spacer()
                }
            }
            .padding(.top, 38)
            .padding(.bottom, 20)
            .padding(.horizontal)
            customDivider
        }
    }


    var nameInput: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text("이름")
                    .profileInputTitle()
                Spacer()
            }
            .padding(.top, 20)
            HStack(spacing: 0) {
                TextField("Required", text: $observed.name)
                    .profileTextField()
            }
            .padding(.top, 5)
            customDivider
                .padding(.top, 15)
        }
        .padding(.leading)
    }

    var nicknameInput: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text("닉네임")
                    .profileInputTitle()
                Spacer()
            }
            .padding(.top, 20)
            HStack(spacing: 0) {
                TextField("Optional", text: $observed.nickname)
                    .profileTextField()
            }
            .padding(.top, 5)
            customDivider
                .padding(.top, 15)
        }
        .padding(.leading)
    }

    var jobTitleInput: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text("직군")
                    .profileInputTitle()
                Spacer()
            }
            .padding(.top, 20)
            HStack(spacing: 0) {
                TextField("Required", text: $observed.jobTitle)
                    .profileTextField()
            }
            .padding(.top, 5)
            customDivider
                .padding(.top, 15)
        }
        .padding(.leading)
    }

    var linkedinInput: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text("링크드인 프로필 URL")
                    .profileInputTitle()
                Spacer()
            }
            .padding(.top, 20)
            HStack(spacing: 0) {
                TextField("Optional", text: $observed.linkedinURL)
                    .profileTextField()
            }
            .padding(.top, 5)
            customDivider
                .padding(.top, 15)
        }
        .padding(.leading)
    }

    var privateURL: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text("개인 페이지 URL")
                    .profileInputTitle()
                Spacer()
            }
            .padding(.top, 20)
            HStack(spacing: 0) {
                TextField("Optional", text: $observed.privateURL)
                    .profileTextField()
            }
            .padding(.top, 5)
        }
        .padding(.leading)
    }

    var submitButton: some View {
        Button {
            if observed.isButtonAvailable() {
                observed.didTapRegisterButton()
            }
        } label: {
            Text("등록하기")
                .font(.headline)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 52, maxHeight: 52)
                .foregroundColor(.white)
                .background(observed.isButtonAvailable() ? Color.accentColor : Color.unavailableButtonBackground)
                .cornerRadius(8)
        }
        .padding(.horizontal)
        .padding(.vertical, 44)
    }
}

