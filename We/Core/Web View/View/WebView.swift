//
//  WebView.swift
//  We
//
//  Created by Om Preetham Bandi on 9/23/24.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    @ObservedObject var viewModel: WebViewModel
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: viewModel.url)
        uiView.load(request)
    }
}
