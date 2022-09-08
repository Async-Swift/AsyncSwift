//
//  WebView.swift
//  AsyncSwift
//
//  Created by Eunyeong Kim on 2022/09/09.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {

    let url: String

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.scrollView.isScrollEnabled = true

        if let url = URL(string: url) {
            webView.load(URLRequest(url: url))
        }

        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}
}
