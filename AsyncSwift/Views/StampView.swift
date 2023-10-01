//
//  StampView.swift
//  AsyncSwift
//
//  Created by Inho Choi on 2022/10/29.
//

import SwiftUI

struct StampView: View {
    @StateObject var observed = Observed()
    @EnvironmentObject var envObserved: MainTabViewObserved
    let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible())
    ]
    
    var body: some View {
        
        GeometryReader { proxy in
            NavigationView {
                ScrollView(showsIndicators: false) {
                    ScrollViewReader { reader in
                        LazyVGrid(
                            columns: columns,
                            spacing: 10
                        ) {
                            ForEach(observed.cards, id: \.event) { card in
                                cardView(card: card, size: proxy.size)
                            }
                        }
                        .padding(.horizontal, 14)
                    }
                }
                .navigationTitle(Tab.stamp.title)
                .overlay {
                    if observed.isLoading {
                        loadingIndicator
                    } else if !observed.isLoading, observed.cards.isEmpty  {
                        emptyCardView
                            .padding(36)
                    }
                }
            }
        }
    }
}

private extension StampView {
    
    @ViewBuilder var loadingIndicator: some View {
        ProgressView()
            .scaleEffect(1.5)
            .padding(30)
            .background(.ultraThinMaterial)
            .cornerRadius(10)
    }
    
    @ViewBuilder var emptyCardView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .strokeBorder(Color(red: 0.78, green: 0.78, blue: 0.8), style: StrokeStyle(lineWidth: 2, dash: [10]))
            Text("아직 참여한 행사가 없습니다.")
                .foregroundColor(.gray)
        }
    }
    
    @ViewBuilder func cardView(card: Card, size: CGSize) -> some View {
        card.image
            .resizable()
            .aspectRatio(contentMode: .fill)
            .shadow(color: Color.black.opacity(0.1), radius: 10, y: 4)
    }
}
