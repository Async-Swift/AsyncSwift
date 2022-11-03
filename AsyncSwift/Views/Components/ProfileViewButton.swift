//
//  ProfileViewButton.swift
//  AsyncSwift
//
//  Created by Kim Insub on 2022/11/02.
//

import SwiftUI

struct ProfileViewButton: View {

    var title: String
    var linkTo: AnyView

    var body: some View {
        NavigationLink {
            linkTo
        } label: {
            HStack {
                Text(title)
                    .font(.headline)
                Spacer()
                Image(systemName: "chevron.forward")
            }
            .foregroundColor(.black)
            .padding(.horizontal, 19)
            .padding(.vertical, 23)
            .frame(maxWidth: .infinity, maxHeight: 68)
            .background(Color.buttonBackground)
            .cornerRadius(15)
            .padding(.horizontal)
        }
    }
}
