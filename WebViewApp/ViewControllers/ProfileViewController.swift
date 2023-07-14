//
//  ProfileViewController.swift
//  WebViewApp
//
//  Created by Vsevolod Lashin on 14.07.2023.
//

import UIKit

final class ProfileViewController: UIViewController {

    private let networkManager = NetworkManager.shared
    private var items: [Item] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        navigationController?.navigationBar.tintColor = .white
    }
    
    private func fetchUser() {
        let url = "https://api.vk.com/method/users.get?user_ids=\(NetworkManager.userID)&fields=city,online,photo_100&access_token=\(NetworkManager.token)&v=5.131"
        guard let url = URL(string: url) else { return }
        
        networkManager.fetch(FriendResponse.self, from: url) { [weak self] result in
            switch result {
            case .success(let response):
                self?.items = response.response.items
            case .failure(let error):
                print(error)
            }
        }
    }
}
