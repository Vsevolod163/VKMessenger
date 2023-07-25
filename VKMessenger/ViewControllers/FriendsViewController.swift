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
    private let storageManager = StorageManager.shared
    
    private var items: [FriendItem] = []
    private var allFriends: [Friend] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "person"),
            style: .plain,
            target: self,
            action: #selector(profileButtonPressed)
        )
        
        navigationItem.rightBarButtonItem?.tintColor = Interface.textColor
        tableView.register(FriendViewCell.self, forCellReuseIdentifier: cellID)
        fetchData()
        tableView.rowHeight = 130
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
                self?.fetchFriends()
                
                self?.allFriends.forEach { friend in
                    self?.storageManager.deleteFriend(friend)
                }
                
                self?.allFriends = []
                
                self?.items.forEach { item in
                    self?.storageManager.createFriend(
                        id: item.id,
                        firstName: item.firstName ?? "",
                        lastName: item.lastName ?? "",
                        city: item.city?.title ?? "",
                        online: item.online,
                        photoTwoHundred: item.photoTwoHundred ?? ""
                    )
                }
                
                self?.fetchFriends()
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func fetchFriends() {
        storageManager.fetchFriends { result in
            switch result {
            case .success(let friends):
                allFriends = friends
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension FriendsViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        allFriends.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        guard let cell = cell as? FriendViewCell else { return UITableViewCell() }
        
        cell.selectionStyle = .none
        cell.backgroundColor = Interface.cellColor
        let friend = allFriends[indexPath.row]
        cell.configure(with: friend)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatVC = ChatViewController()
        chatVC.id = items[indexPath.row].id
        
        navigationController?.pushViewController(chatVC, animated: true)
    }
}

