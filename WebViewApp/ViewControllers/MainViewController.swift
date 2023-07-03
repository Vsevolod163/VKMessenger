//
//  ViewController.swift
//  WebViewApp
//
//  Created by Vsevolod Lashin on 02.07.2023.
//

import UIKit
import WebKit

final class MainViewController: UIViewController, WKNavigationDelegate {

    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.navigationDelegate = self
        
        return webView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(webView)
        setConstraints()
        
        if let url = URL(string: "https://oauth.vk.com/authorize?client_id=51694916&redirect_uri=https://oauth.vk.com/blank.html&scope=friends,groups,photos&display=mobile&response_type=token") {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        guard let url = navigationResponse.response.url, url.path == "/blank.html", let fragment = url.fragment else {
            decisionHandler(.allow)
            return
        }
        
        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                
                return dict
            }
        let token = params["access_token"] ?? ""
        let userID = params["user_id"] ?? ""
        print(token as String)
        print(userID as String)
        decisionHandler(.cancel)
        webView.removeFromSuperview()
        present(TabBarController(), animated: true)
    }
    
    private func setConstraints() {
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                webView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
                webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                webView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
            ]
        )
    }

}

