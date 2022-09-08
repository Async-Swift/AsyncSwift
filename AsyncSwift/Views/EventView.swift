//
//  ScheduleView.swift
//  AsyncSwift
//
//  Created by Kim Insub on 2022/09/06.
//

import SwiftUI

struct EventView: View {

    let schedules: [ScheduleModel] = [
        ScheduleModel(id: 0, time: "12:00 - 13:00", title: "사랑해요 Swift", desc: "어쩌구", speaker: SpeakerModel(name: "김어쩔", image: "someImage")),
        ScheduleModel(id: 1, time: "12:00 - 13:00", title: "사랑해요 Swift", desc: "어쩌구", speaker: SpeakerModel(name: "김어쩔", image: "someImage")),
        ScheduleModel(id: 2, time: "12:00 - 13:00", title: "사랑해요 Swift", desc: "어쩌구", speaker: SpeakerModel(name: "김어쩔", image: "someImage")),
        ScheduleModel(id: 3, time: "12:00 - 13:00", title: "사랑해요 Swift", desc: "어쩌구", speaker: SpeakerModel(name: "김어쩔", image: "someImage")),
        ScheduleModel(id: 4, time: "12:00 - 13:00", title: "사랑해요 Swift", desc: "어쩌구", speaker: SpeakerModel(name: "김어쩔", image: "someImage")),
    ]

    var body: some View {
        NavigationView {
            List {
                ForEach(schedules, id: \.id) { schedule in
                    ZStack {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(schedule.time)
                                    .foregroundColor(.gray)
                                    .fontWeight(.semibold)
                                    .font(.system(size: 13))
                                    .padding(.bottom, 10)
                                Text(schedule.title)
                                    .fontWeight(.semibold)
                                    .font(.system(size: 20))
                                Text("by \(schedule.speaker.name)")
                                    .fontWeight(.semibold)
                                    .font(.system(size: 20))
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(Color(red: 138 / 255, green: 138 / 255, blue: 142 / 255))
                                .font(.title2)
                        }
                        .padding(.vertical, 30)
                        NavigationLink(destination: Text("Hello World")) { Text("") }
                            .opacity(0)
                    }
                    .listRowSeparatorTint(Color(red: 59 / 255, green: 59 / 255, blue: 59 / 255))
                }
                .frame(height: 139)
            }
            .listStyle(.plain)
            .navigationTitle("일정")
        }
    }
}

//struct ScheduleView_Previews: PreviewProvider {
//    static var previews: some View {
//        ScheduleView()
//    }
//}

