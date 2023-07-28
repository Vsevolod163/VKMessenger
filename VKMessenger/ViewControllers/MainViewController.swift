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

        if let url = URL(
            string: "https://oauth.vk.com/authorize?client_id=51704618&redirect_uri" +
            "=https://oauth.vk.com/blank.html&scope=friends,groups,photos&display=mobile&response_type=token") {
            let request = URLRequest(url: url)
            webView.load(request)
        }
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }

    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationResponse: WKNavigationResponse,
        decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void
    ) {
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

        NetworkManager.token = token
        NetworkManager.userID = userID

        decisionHandler(.cancel)
        webView.removeFromSuperview()

        let tabBarController = setupTabBarController(withToken: token, andUserId: userID)

        navigationController?.pushViewController(tabBarController, animated: true)
    }

    private func setupTabBarController(withToken token: String, andUserId userID: String) -> UITabBarController {
        let tabBarController = UITabBarController()

        tabBarController.tabBar.backgroundColor = .darkGray
        tabBarController.tabBar.tintColor = .white
        tabBarController.tabBar.unselectedItemTintColor = .lightGray
        tabBarController.modalPresentationStyle = .fullScreen

        let friendsVC = FriendsViewController()
        let groupsVC = GroupsViewController()

        let flowLayout = UICollectionViewFlowLayout()
        let photosVC = PhotosViewController(collectionViewLayout: flowLayout)

        friendsVC.title = "Friends"
        friendsVC.tabBarItem.image = UIImage(systemName: "person")

        groupsVC.title = "Groups"
        groupsVC.tabBarItem.image = UIImage(systemName: "person.2")

        photosVC.title = "Photos"
        photosVC.tabBarItem.image = UIImage(systemName: "photo")

        tabBarController.viewControllers = [UINavigationController.init(rootViewController: friendsVC), groupsVC, photosVC]
        tabBarController.navigationItem.hidesBackButton = true

        return tabBarController
    }

    private func setConstraints() {
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                webView.topAnchor.constraint(equalTo: view.topAnchor),
                webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ]
        )
    }

}
