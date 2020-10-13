//
//  BrowserView.swift
//  FaceValidator
//
//  Created by Bryan Bolivar on 9/10/20.
//

import SwiftUI
import WebKit


struct BrowserView: View {
    var post: Post
    
    var body: some View {
        WebView(urlString: post.storyURL)
    }
}

struct BrowserView_Previews: PreviewProvider {
    static var previews: some View {
        BrowserView(post: Post.data)
        .edgesIgnoringSafeArea(.all)
    }
}



/// View created as a workaround implementation of UIWebView for SwiftUI
struct WebView: UIViewRepresentable {
    
    /// String representation of the URL you want to open in the WebView.
    let urlString: String?

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let safeString = urlString, let url = URL(string: safeString) {
            let request = URLRequest(url: url)
            uiView.load(request)
        }
    }

}
