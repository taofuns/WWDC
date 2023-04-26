//
//  WebView.swift
//  WWDC
//
//  Created by Leon on 2022/10/2.
//



import SwiftUI
import WebKit
 

#if os(iOS)

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
#endif

#if os(macOS)

struct WebView: NSViewRepresentable {

    var url: URL

    func makeNSView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()

        
        return WKWebView(frame: .zero, configuration: config)
    }

    func updateNSView(_ webView: WKWebView, context: Context) {
        let strUrl = url.description.replacingOccurrences(of: "dl=1", with: "dl=0")
        let finalUrl = URL(string: strUrl)!
        let request = URLRequest(url: finalUrl)
        webView.load(request)
    }
}

#endif

