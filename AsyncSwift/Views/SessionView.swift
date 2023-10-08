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

private extension SessionView {

    var sessionDetail: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(session.title)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding(.vertical, 24)
                Spacer(minLength: 0)
            }
            VStack(alignment: .leading, spacing: 8) {
                ForEach(session.description, id: \.self) { paragraph in
                    Text(paragraph.content)
                }
            }
            .padding(.bottom, 80)
        }
        .frame(width: UIScreen.main.bounds.width - 32)
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
                    .frame(width: speakerImageSize, height: speakerImageSize)
                    .scaledToFit() 
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

struct SessionView_Previews: PreviewProvider {
    static var previews: some View {
        SessionView(
            session: .init(
                id: 0,
                title: "[Event] 사이드 프로젝트가 메인 JOB이 되기까지의 이야기",
                description: [
                    .init(content: "사이드 프로젝트가 메인 JOB이 되기까지 이야기")
                ],
                speaker: .init(
                    name: "박성은",
                    imageURL: "https://github.com/Async-Swift/jsonstorage/blob/main/Images/Speaker/syncswift2023/hyeonjung.png?raw=true",
                    role: "북적 스튜디오 | iOS Developer",
                    description: "iOS 개발자 입니다."
                )
            )
        )
    }
}
