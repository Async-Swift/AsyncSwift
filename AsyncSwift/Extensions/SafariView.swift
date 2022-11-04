//
//  SafariView.swift
//  AsyncSwift
//
//  Created by Kim Insub on 2022/11/04.
//

import Foundation
import SwiftUI
import SafariServices

struct SafariView: UIViewControllerRepresentable {
    let url: String
    func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
        let URL = URL(string: url) 
        return SFSafariViewController(url: URL!)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariView>) {

    }
}
