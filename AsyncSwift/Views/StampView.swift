//
//  StampView.swift
//  AsyncSwift
//
//  Created by Kim Insub on 2022/09/08.
//

import SwiftUI

struct StampView: View {
    var tempisScanned = true

    @State private var backDegree: Double = 0.0
    @State private var frontDegree: Double = -90.0
    @State private var isFlipped = false

    let durationAndDelay: CGFloat = 0.3

    var body: some View {
        NavigationView {
            Group {
                if tempisScanned {
                    Button(action: { flipCard() }) {
                        ZStack {
                            stampBack
                            stampFront
                        }
                    }
                } else {
                    notScannedView
                }
            }
                .padding(36)
                .navigationTitle("Stamp")
        }
    } // body

    //MARK: Flip Card Function
    func flipCard () {
        isFlipped.toggle()
        
        if isFlipped { // 카드 회전 연속을 위해서 if문 분리
            withAnimation(.linear(duration: durationAndDelay)) {
                backDegree = 90
            }
            withAnimation(.linear(duration: durationAndDelay).delay(durationAndDelay)) {
                frontDegree = 0
            }
        } else {
            withAnimation(.linear(duration: durationAndDelay)) {
                frontDegree = -90
            }
            withAnimation(.linear(duration: durationAndDelay).delay(durationAndDelay)) {
                backDegree = 0
            }
        }
    }
} // View

private extension StampView {
    @ViewBuilder
    var stampBack: some View {
        Image("Seminar002StampBack")
            .shadow(color: Color(.sRGB, red: 0, green: 0, blue: 0, opacity: 0.2), radius: 20, x: 0, y: 4) //TODO: 디자인 수정 사항이 있습니다.
            .rotation3DEffect(Angle(degrees: frontDegree), axis: (x: 0, y: 1, z: 0))
    }

    @ViewBuilder
    var stampFront: some View {
        Image("Seminar002StampFront")
            .shadow(color: Color(.sRGB, red: 0, green: 0, blue: 0, opacity: 0.2), radius: 20, x: 0, y: 4) //TODO: 디자인 수정 사항이 있습니다.
            .rotation3DEffect(Angle(degrees: backDegree), axis: (x: 0, y: 1, z: 0))
    }

    @ViewBuilder
    var notScannedView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .strokeBorder(Color(red: 0.78, green: 0.78, blue: 0.8), style: StrokeStyle(lineWidth: 2, dash: [10]))

            Text("아직 참여한 행사가 없습니다.")
                .foregroundColor(.gray)
        }
    }
}

struct StampView_Previews: PreviewProvider {
    static var previews: some View {
        StampView()
    }
}
