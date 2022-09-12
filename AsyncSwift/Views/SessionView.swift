//
//  SessionView.swift
//  AsyncSwift
//
//  Created by Kim Insub on 2022/09/08.
//

import SwiftUI

struct SessionView: View {

    private let session: EventModel.Session

    init(session: EventModel.Session) {
        self.session = session
    }

    var body: some View {
        ZStack {
            ScrollView {
                Group {
                    customDivider
                        .padding(.top, 10)
                        .padding(.bottom, 4)
                    sessionDetail
                }
                .background(.white)
                speakerDetail
            }
            .navigationTitle("Session")
        }
    }
}

private extension SessionView {

    var sessionDetail: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(session.title)
                .font(.title3)
                .fontWeight(.semibold)
                .padding(.vertical, 24)
            VStack(alignment: .leading, spacing: 8) {
                ForEach(session.description, id: \.self) { paragraph in
                    Text(paragraph.content)
                }
            }
            .padding(.bottom, 80)
        }
        .padding(.horizontal, 24)
    }

    var speakerDetail: some View {
        VStack(alignment: .leading, spacing: 4) {
            AsyncImage(url: URL(string: session.speaker.imageURL)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
                    .frame(width: 80, height: 80)
            } placeholder: {
                Image(systemName: "person.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
                    .frame(width: 80, height: 80)
                    .opacity(0.4)
            }
            .padding(.vertical, 24)
            VStack(alignment: .leading, spacing: 2) {
                Text("\(session.speaker.name) 님")
                    .font(.headline)
                Text(session.speaker.role)
                    .font(.caption2)
            }
            Text(session.speaker.description)
                .font(.footnote)
        }
        .padding(.bottom, 60)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 32)
        .background(Color.speakerBackground)
    }
}
