//
//  StampView.swift
//  AsyncSwift
//
//  Created by Kim Insub on 2022/09/08.
//

import SwiftUI

struct StampView: View {
    @EnvironmentObject var appData: AppData
    @ObservedObject var observed = Observed()

    var body: some View {
        NavigationView {
            Group {
                if appData.isStampExist() {
                    ZStack {
                        stampBack
                        stampFront
                    }
                        .onTapGesture {
                        observed.didTabCard()
                    }
                } else {
                    notScannedView
                }
            }
                .padding(36)
                .navigationTitle("Stamp")
        }
    } // body
} // View

private extension StampView {

    @ViewBuilder
    var stampBack: some View {
        Image("Seminar002StampBack")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .shadow(color: Color(.sRGB, red: 0, green: 0, blue: 0, opacity: 0.2), radius: 20, x: 40 * observed.cardAnimatonModel.frontDegree / 90, y: 4)
            .rotation3DEffect(Angle(degrees: observed.cardAnimatonModel.frontDegree), axis: (x: 0, y: 1, z: 0))
    }

    @ViewBuilder
    var stampFront: some View {
        Image("Seminar002StampFront")

            .resizable()
            .aspectRatio(contentMode: .fit)
            .shadow(color: Color(.sRGB, red: 0, green: 0, blue: 0, opacity: 0.2), radius: 20, x: 40 * observed.cardAnimatonModel.backDegree / 90, y: 4)
            .rotation3DEffect(Angle(degrees: observed.cardAnimatonModel.backDegree), axis: (x: 0, y: 1, z: 0))
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
