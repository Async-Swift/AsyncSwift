//
//  StampView.swift
//  AsyncSwift
//
//  Created by Kim Insub on 2022/09/08.
//

import SwiftUI

struct StampView: View {
    var tempisScanned: Bool = true
    @State var isStampClicked: Bool = false

    @State var backDegree = 0.0
    @State var frontDegree = -90.0
    @State var isFlipped = false

    let durationAndDelay: CGFloat = 0.3

    var body: some View {
        NavigationView {
            Group {
                Button(action: {flipCard() }) {
                    ZStack {
                        StampBack()
                        StampFront()
                    }
                }
            }
                .padding(EdgeInsets(top: 44, leading: 36, bottom: 36, trailing: 46))
                .navigationTitle("Stamp")
        }
    } // body
    
    @ViewBuilder
    func StampFront() -> some View {
        Image("Seminar002StampBack")
            .shadow(color: Color(.sRGB, red: 0, green: 0, blue: 0, opacity: 0.2), radius: 20, x: 0, y: 4)
            .rotation3DEffect(Angle(degrees: backDegree), axis: (x: 0, y: 1, z: 0))
    }
    
    @ViewBuilder
    func StampBack() -> some View {
        Image("Seminar002StampFront")
            .shadow(color: Color(.sRGB, red: 0, green: 0, blue: 0, opacity: 0.2), radius: 20, x: 0, y: 4)
            .rotation3DEffect(Angle(degrees: frontDegree), axis: (x: 0, y: 1, z: 0))
    }
    

    @ViewBuilder
    func notScannedView() -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .strokeBorder(.gray, style: StrokeStyle(lineWidth: 2, dash: [10]))

            Text("아직 참여한 행사가 없습니다.")
                .foregroundColor(.gray)
        }
    }

    
    //MARK: Flip Card Function
    func flipCard () {
        isFlipped = !isFlipped
        if isFlipped {
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

struct StampView_Previews: PreviewProvider {
    static var previews: some View {
        StampView()
    }
}
