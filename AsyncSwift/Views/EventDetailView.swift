//
//  EventDetailView.swift
//  AsyncSwift
//
//  Created by Kim Insub on 2022/09/08.
//

import SwiftUI

// TODO
// 1. "캘린더에 추가" Button Action 기능 구현하고 연결하기
// 2. "지도로 길찾기" Button Action 기능 구현하고 연결하기

struct EventDetailView: View {

    let event: EventModel.Event

    init(event: EventModel.Event) {
        self.event = event
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Divider()
                    .padding(.top, 10)
                description
                Divider()
                information
                Spacer()
            }
        }
        .navigationTitle(event.detailTitle)
    }
}

private extension EventDetailView {

    var description: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(event.subject)
                .fontWeight(.bold)
                .font(.title3)
                .font(.system(size: 20))
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
                Button {

                } label: {
                    Text("캘린더에 추가")
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
