//
//  EventDetailView.swift
//  AsyncSwift
//
//  Created by Kim Insub on 2022/09/08.
//

import SwiftUI

struct EventDetailView: View {

    private let event: EventModel.Event
    @StateObject var observed = Observed()

    init(event: EventModel.Event) {
        self.event = event
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                customDivider
                    .padding(.top, 10)
                description
                customDivider
                information
                Spacer()
            }
        }
        .navigationTitle(event.detailTitle)
        .confirmationDialog("", isPresented: $observed.isShowingSheet, titleVisibility: .hidden) {
            if let naverMapURL = URL(string: event.addressURLs.naverMapURL) {
                Link("네이버 지도로 길 찾기", destination: naverMapURL)
            }
            if let kakaoMapURL = URL(string: event.addressURLs.kakaoMapURL) {
                Link("카카오맵으로 길 찾기", destination: kakaoMapURL)
            }
        }
    }
}

private extension EventDetailView {

    var description: some View {
        VStack(alignment: .leading) {
            Text(event.subject)
                .fontWeight(.bold)
                .font(.title3)
            ForEach(event.description, id:\.self) { paragraph in
                Text(paragraph.content)
                    .font(.body)
            }
            Text(event.hashTags)
                .padding(.top, 8)
                .foregroundColor(.gray)
                .font(.body)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 30)
    }

    var information: some View {
        VStack(alignment: .leading, spacing: 40) {
            VStack(alignment: .leading, spacing: 8) {
                Text("\(Image(systemName: "calendar")) Date and time")
                    .font(.title3)
                    .fontWeight(.semibold)
                Text("\(event.date)\n\(event.time)")
                    .font(.body)
                Button("캘린더에 추가") {
                    observed.isShowingAlert = true
                }
                .alert(isPresented: $observed.isShowingAlert) {
                    Alert(
                        title: Text("'AsyncSwift'이(가) 사용자의 캘린터에 접근하려고 합니다."),
                        message: Text("사용자의 '캘린더'에 접근하도록 허용합니다."),
                        primaryButton: .default(Text("허용 안 함")) {
                            observed.isShowingAlert = false
                        },
                        secondaryButton: .default(Text("확인")) {
                            observed.additionConfirmed()
                        }
                    )
                }
                .alert("일정 등록 완료", isPresented: $observed.isShowingSuccessAlert, actions: { }, message: {
                    Text("세미나 일정이 캘린더에 추가되었습니다.")
                })
                .alert("일정 등록 실패", isPresented: $observed.isShowingFailureAlert, actions: { }, message: {
                    Text("세미나 일정 등록이 실패하였습니다.")
                })

            VStack(alignment: .leading, spacing: 8) {
                Text("\(Image(systemName: "location.fill")) Location")
                    .font(.title3)
                    .fontWeight(.semibold)
                VStack(alignment: .leading) {
                    Text(event.location)
                    Text(event.address)
                }
                Button {
                    observed.isShowingSheet = true
                } label: {
                    Text("지도로 길찾기")
                }
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 30)
        }
    }
}
