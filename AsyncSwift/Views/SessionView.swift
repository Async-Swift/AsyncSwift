//
//  SessionView.swift
//  AsyncSwift
//
//  Created by Kim Insub on 2022/09/08.
//

import SwiftUI

struct SessionView: View {

    @ObservedObject var observed: Observed

    init(session: Session) {
        observed = Observed(session: session)
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
            Text(observed.session.title)
                .font(.title3)
                .fontWeight(.semibold)
                .padding(.vertical, 24)
            VStack(alignment: .leading, spacing: 8) {
                ForEach(observed.session.description, id: \.self) { paragraph in
                    Text(paragraph.content)
                }
            }
            .padding(.bottom, 80)
        }
        .padding(.horizontal, 24)
    }

    var speakerDetail: some View {
        VStack(alignment: .leading, spacing: 4) {
            AsyncImage(url: URL(string: observed.session.speaker.imageURL), transaction: Transaction(animation: .default)) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                } else if phase.error != nil {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .opacity(0.04)
                } else {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .opacity(0.04)
                }
            }
            .aspectRatio(contentMode: .fit)
            .frame(width: observed.speakerImageSize, height: observed.speakerImageSize)
            .clipShape(Circle())
            .padding(.vertical, 24)
            VStack(alignment: .leading, spacing: 2) {
                Text("\(observed.session.speaker.name) 님")
                    .font(.headline)
                Text(observed.session.speaker.role)
                    .font(.caption2)
            }
            Text(observed.session.speaker.description)
                .font(.footnote)
        }
        .padding(.bottom, 60)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 32)
        .background(Color.speakerBackground)
    }
}
