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
        Group {
            if observed.cards.isEmpty {
                emptyCardView
                    .padding(36)
            } else {
                ScrollView(showsIndicators: false) {
                    ScrollViewReader { value in
                        ZStack {
                            ForEach(0..<observed.cards.count, id: \.self) { index in
                                observed.cards[observed.events[index]]?.currentImage?
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .offset(y: observed.getCardOffsetY(index: index))
                                    .onTapGesture {
                                        observed.didCardTapped(index: index)
                                    }
                            }
                        }
                        .offset(y: UIScreen.main.bounds.height / 2)
                    }
                    Spacer(minLength: observed.isExpand ? UIScreen.main.bounds.height : 0)
                }
                .padding()
            }
        } // Group
        .onOpenURL{ url in
            Task {
                await observed.openByLink(url: url)
            }
        }
    } // body
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
    
    
}

struct StampView_Previews: PreviewProvider {
    static var previews: some View {
        StampView()
            .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro Max"))
        
        StampView()
            .previewDevice(PreviewDevice(rawValue: "iPhone SE (3rd generation)"))
    }
}


