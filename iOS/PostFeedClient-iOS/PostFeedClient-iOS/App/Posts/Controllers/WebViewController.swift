//
//  WebViewController.swift
//  PostFeedClient-iOS
//
//  Created by Bryan A Bolivar M on 10/11/20.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {

    /// WebView which shows Post url
    @IBOutlet weak var webView: WKWebView!
    
    /// Post Object received for displaying on Screen
    var post: Post?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = post?.url {
            webView.load(URLRequest(url: url))
        }
        webView.allowsBackForwardNavigationGestures = true
    }
}
