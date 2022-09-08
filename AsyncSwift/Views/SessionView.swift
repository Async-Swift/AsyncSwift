//
//  SessionView.swift
//  AsyncSwift
//
//  Created by Kim Insub on 2022/09/08.
//

import SwiftUI

struct SessionView: View {

    let data: EventModel.Session

    init(session: EventModel.Session) {
        data = session
    }

    var body: some View {
        ScrollView {
            Divider()
                .padding(.top, 10)
                .padding(.bottom, 4)
            VStack(alignment: .leading) {
                Text(data.title)
                    .fontWeight(.semibold)
                    .font(.system(size: 20))
                    .padding(.vertical, 24)

                VStack(alignment: .leading, spacing: 8) {
                    ForEach(data.description, id: \.self) { paragraph in
                        Text(paragraph.content)
                    }
                }
                .padding(.bottom, 80)
            }
            .padding(.horizontal, 24)
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Circle()
                        .frame(width: 80, height: 80, alignment: .leading)
                        .padding(.vertical, 24)
                    Spacer()
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text("\(data.speaker.name) 님")
                        .fontWeight(.semibold)
                        .font(.system(size: 17))
                    Text(data.speaker.role)
                        .fontWeight(.regular)
                        .font(.system(size: 11))
                }
                Text(data.speaker.description)
                    .fontWeight(.regular)
                    .font(.system(size: 13))
                    .padding(.bottom, 60)

            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal, 32)
            .background(.gray.opacity(0.1))

        }
        .navigationTitle("Session")

    }
}

//struct SessionView_Previews: PreviewProvider {
//    static var previews: some View {
//        SessionView()
//    }
//}
