//
//  WebViewViewer.swift
//  We
//
//  Created by Om Preetham Bandi on 9/23/24.
//

import SwiftUI

struct WebViewViewer: View {
    @StateObject var viewModel: WebViewModel
    
    var body: some View {
        WebView(viewModel: viewModel)
    }
}
