//
//  EventDetailView.swift
//  AsyncSwift
//
//  Created by Kim Insub on 2022/09/08.
//

import SwiftUI

// TODO: 내용
// 1. "캘린더에 추가" Button Action 기능 구현하고 연결하기
// 2. "지도로 길찾기" Button Action 기능 구현하고 연결하기

struct EventDetailView: View {

    private let event: EventModel.Event
    @StateObject var observed = Observed()

    init(event: EventModel.Event) {
        self.event = event
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                CustomDivider()
                    .padding(.top, 10)
                description
                CustomDivider()
                information
                Spacer()
            }
        }
        .navigationTitle(event.detailTitle)
        .confirmationDialog("Are you sure you want to do this?", isPresented: $observed.showSheet, titleVisibility: .visible) {
            Link("네이버 지도로 길 찾기", destination: URL(string: "https://map.naver.com/v5/entry/place/1019717788?c=14396419.6520108,4302029.7423806,15,0,0,0,dh")!)
            Link("카카오맵으로 길 찾기", destination: URL(string: "http://kko.to/ONFeYdS33")!)
        }

    }
}

private extension EventDetailView {

    var description: some View {
        VStack(alignment: .leading, spacing: 8) {
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
                    .fontWeight(.semibold)
                    .font(.system(size: 20))
                Text("\(event.date)\n\(event.time)")
                    .font(.body)
                Button("캘린더에 추가") {
                    observed.showingAlert = true
                }
                .alert(isPresented: $observed.showingAlert) {
                    Alert(
                        title: Text("'AsyncSwift'이(가) 사용자의 캘린터에 접근하려고 합니다."),
                        message: Text("사용자의 '캘린더'에 접근하도록 허용합니다."),
                        primaryButton: .default(Text("허용 안 함")) {
                            observed.showingAlert = false
                        },
                        secondaryButton: .default(Text("확인")) {
                            observed.addEventOnCalendar()
                        }
                    )
                }
            }
            VStack(alignment: .leading, spacing: 8) {
                Text("\(Image(systemName: "location.fill")) Location")
                    .fontWeight(.semibold)
                    .font(.system(size: 20))
                VStack(alignment: .leading) {
                    Text("\(Text(event.location).fontWeight(.semibold)), \(Text(event.detailLocation))")
                    Text(event.address)
                }
                Button {
                    observed.showSheet = true
                } label: {
                    Text("지도로 길찾기")
                }
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 30)
    }
}

//struct EventDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        EventDetailView()
//    }
//}
