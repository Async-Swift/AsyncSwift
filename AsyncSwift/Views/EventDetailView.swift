//
//  EventDetailView.swift
//  AsyncSwift
//
//  Created by Kim Insub on 2022/09/08.
//

import SwiftUI

struct EventDetailView: View {

    let data = EventModel.mockData

    var body: some View {

        ScrollView {
            VStack(alignment: .leading) {
                Divider()
                    .padding(.top, 10)
                VStack(alignment: .leading, spacing: 8) {
                    Text(data.event.subject)
                        .fontWeight(.bold)
                        .font(.system(size: 24))
                    ForEach(data.event.description, id:\.self) { paragraph in
                        Text(paragraph.content)
                            .font(.system(size: 17))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    Text(data.event.hashTags)
                        .padding(.top, 8)
                        .foregroundColor(.gray)
                        .font(.system(size: 17))
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 30)
                Divider()
                VStack(alignment: .leading, spacing: 40) {

                    VStack(alignment: .leading, spacing: 8) {
                        Text("\(Image(systemName: "calendar")) Date and time")
                            .fontWeight(.semibold)
                            .font(.system(size: 20))
                        Text("\(data.event.date)\n\(data.event.time)")
                            .fontWeight(.regular)
                            .font(.system(size: 17))
                            .fixedSize(horizontal: false, vertical: true)
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
                            Text("\(Text(data.event.location).fontWeight(.semibold)), \(Text(data.event.detailLocation))")
                                .fixedSize(horizontal: false, vertical: true)
                            Text(data.event.address)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        Button {

                        } label: {
                            Text("지도로 길찾기")
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 30)
                Spacer()
            }
        }
        .navigationTitle(data.event.detailTitle)
    }
}

//struct EventDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        EventDetailView()
//    }
//}
