//
//  WebView.swift
//  BASE
//
//  Created by MAXWELL TAWIAH on 1/17/25.
//

import Foundation
import SwiftUI
import WebKit

// MARK: - WebView Wrapper
struct WebView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}

// MARK: - FullScreenWebView
struct FullScreenWebView: View {
    @Binding var previewUrl: String
    @Binding var title: String
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            if let url = URL(string: previewUrl) {
                WebView(url: url)
                    .edgesIgnoringSafeArea(.all)
                    .navigationBarTitle(title, displayMode: .inline)
                    .navigationBarItems(trailing: Button("Done") {
                        dismiss()
                    })
            } else {
                Text("Invalid URL")
                    .font(.headline)
                    .foregroundColor(.red)
            }
        }
    }
}

