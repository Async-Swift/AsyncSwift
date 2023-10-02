//
//  SessionView.swift
//  AsyncSwift
//
//  Created by Kim Insub on 2022/09/08.
//

import SwiftUI
import SDWebImageSwiftUI

struct SessionView: View {

    let session: Session
    let speakerImageSize: CGFloat = 80
    
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
        HStack(spacing: 0) {
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
            Spacer()
        }
    }

    var speakerDetail: some View {

        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 4) {
                
                WebImage(url: URL(string: session.speaker.imageURL))
                    .resizable()
                    .placeholder {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .frame(width: speakerImageSize, height: speakerImageSize)
                            .opacity(0.04)
                    }
                    .transition(.fade)
                    .scaledToFit()
                    .frame(width: speakerImageSize, height: speakerImageSize)
                    .clipShape(Circle())
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
            .padding(.horizontal, 32)
            .padding(.bottom, 60)

            Spacer()
        }
        .background(Color.speakerBackground)
    }
}
