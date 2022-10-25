//
//  WebView.swift
//  WWDC
//
//  Created by Leon on 2022/10/2.
//

import SwiftUI
import WebKit
 

struct WebView: UIViewRepresentable {
 
    var url: URL
 
    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        return WKWebView(frame: .zero, configuration: config)
    }
 
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
