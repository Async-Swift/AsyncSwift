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
        UITextView.appearance().backgroundColor = .clear
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
                    introductionInput
                    linkedinInput
                    privateURL
                }
            }
            Spacer()
        }
        .navigationBarTitle("Profile", displayMode: .large)
        .toolbar {
            submitButton
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
                TextField("", text: $observed.name)
                    .profileTextField()
                    .placeholder(
                        when: observed.name.isEmpty,
                        text: "Required",
                        isTextField: true
                    )
                Spacer()
            }
            customDivider
                .padding(.top, 15)
        }
        .padding(.leading)
        .padding(.top, 23)
    }

    var nicknameInput: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text("닉네임")
                    .profileInputTitle()
                TextField("", text: $observed.nickname)
                    .profileTextField()
                    .placeholder(
                        when: observed.nickname.isEmpty,
                        text: "Optional",
                        isTextField: true
                    )
                Spacer()
            }
            customDivider
                .padding(.top, 15)
        }
        .padding(.leading)
        .padding(.top, 23)
    }

    var jobTitleInput: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text("직군")
                    .profileInputTitle()
                TextField("", text: $observed.jobTitle)
                    .profileTextField()
                    .placeholder(
                        when: observed.jobTitle.isEmpty,
                        text: "Required",
                        isTextField: true
                    )
                Spacer()
            }
            customDivider
                .padding(.top, 15)
        }
        .padding(.leading)
        .padding(.top, 23)
    }

    var introductionInput: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top, spacing: 0) {
                Text("소개")
                    .profileInputTitle()
                if #available(iOS 16.0, *) {
                    TextEditor(text: $observed.introduction)
                        .profileTextEditor()
                        .scrollContentBackground(.hidden)
                        .placeholder(
                            when: observed.introduction.isEmpty,
                            text: "Optional, 80자 이내",
                            isTextField: false
                        )
                        .offset(x: -2, y: -8)
                } else {
                    TextEditor(text: $observed.introduction)
                        .profileTextEditor()
                        .placeholder(
                            when: observed.introduction.isEmpty,
                            text: "Optional, 80자 이내",
                            isTextField: false
                        )
                }

            }
            customDivider
                .padding(.top, 15)
        }
        .padding(.leading)
        .padding(.top, 23)
        .frame(height: 91)
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
                TextField("", text: $observed.linkedinURL)
                    .profileTextField()
                    .placeholder(
                        when: observed.linkedinURL.isEmpty,
                        text: "Optional",
                        isTextField: true
                    )
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
                TextField("", text: $observed.privateURL)
                    .profileTextField()
                    .placeholder(
                        when: observed.privateURL.isEmpty,
                        text: "Optional",
                        isTextField: true
                    )
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
            Text("Save")
                .foregroundColor(
                    observed.isButtonAvailable() ?
                    Color.accentColor :
                    Color.unavailableButtonBackground
                )
        }
    }
}

