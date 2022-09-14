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
        
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.scrollView.isScrollEnabled = true
        
        
        if let url = URL(string: url) {
            uiView.load(URLRequest(url: url))
        }
    }
}
