//
//  StampView.swift
//  AsyncSwift
//
//  Created by Inho Choi on 2022/10/29.
//

import SwiftUI

struct StampView: View {
    @StateObject var observed = Observed()
    
    var body: some View {
        GeometryReader { geometry in
            if observed.cards.isEmpty {
                emptyCardView
                    .padding(36)
            } else {
                ScrollView(showsIndicators: false) {
                    ScrollViewReader { reader in
                        HStack(alignment: .bottom) {
                            Text("Stamp")
                                .font(.system(size: 34))
                                .fontWeight(.bold)
                                .padding(.leading, 16)
                                .padding(.bottom, 7)
                                .padding(.top, 48)
                            Spacer()
                        }
                        .frame(height: 94)
                        ZStack {
                            ForEach(0..<observed.cards.count, id: \.self) { index in
                                cardView(index: index, size: geometry.size, scrollReader: reader)
                            }
                            .padding(.horizontal, 16)
                        }
                    }
                    Spacer(minLength: observed.getSpacerMinLength(size: geometry.size))
                }
                
            }
        }
        .onOpenURL{ url in
            Task {
                await observed.openByLink(url: url)
            }
        }
    }
}

private extension StampView {
    var emptyCardView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .strokeBorder(Color(red: 0.78, green: 0.78, blue: 0.8), style: StrokeStyle(lineWidth: 2, dash: [10]))
            
            Text("아직 참여한 행사가 없습니다.")
                .foregroundColor(.gray)
        }
    }
    
    func cardView(index: Int, size: CGSize, scrollReader: ScrollViewProxy) -> some View {
        observed.cards[observed.events[index]]?.image
            .resizable()
            .aspectRatio(contentMode: .fit)
            .offset(y: observed.getCardOffsetY(index: index, size: size))
            .onTapGesture {
                observed.didCardTapped(index: index, scrollReader: scrollReader)
            }
    }
}
