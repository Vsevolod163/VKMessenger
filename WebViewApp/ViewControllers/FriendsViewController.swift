//
//  FriendsViewController.swift
//  WebViewApp
//
//  Created by Vsevolod Lashin on 03.07.2023.
//

import UIKit

final class FriendsViewController: UITableViewController {

    private let cellID = "friend"
    private let networkManager = NetworkManager.shared
    private var items: [Item] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "person"),
            style: .plain,
            target: self,
            action: #selector(profileButtonPressed)
        )
        navigationItem.rightBarButtonItem?.tintColor = .white
        
        tableView.register(FriendViewCell.self, forCellReuseIdentifier: cellID)
        fetchData()
        tableView.rowHeight = 130
        view.backgroundColor = .black
    }
    
    @objc private func profileButtonPressed() {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        animation.type = .push
        animation.duration = 0.5
        navigationController?.view.layer.add(animation, forKey: nil)
        navigationController?.pushViewController(ProfileViewController(), animated: true)
    }
    
    private func fetchData() {
        let friendURL = URL(string: "https://api.vk.com/method/friends.get?user_ids=\(NetworkManager.userID)&fields=bdays,city,photo_200_orig,online&access_token=\(NetworkManager.token)&v=5.131")!
        
        networkManager.fetch(FriendResponse.self, from: friendURL) { [weak self] result in
            switch result {
            case .success(let response):
                self?.items = response.response.items
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension FriendsViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        guard let cell = cell as? FriendViewCell else { return UITableViewCell() }
        
        cell.selectionStyle = .none
        cell.backgroundColor = .black
        let item = items[indexPath.row]
        cell.configure(with: item)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.pushViewController(ChatViewController(), animated: true)
    }
}

