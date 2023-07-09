//
//  FriendsViewController.swift
//  WebViewApp
//
//  Created by Vsevolod Lashin on 03.07.2023.
//

import UIKit

final class FriendsViewController: UITableViewController {

    var token: String!
    var userID: String!
    
    private let cellID = "friend"
    private let networkManager = NetworkManager.shared
    private var items: [Item] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(FriendViewCell.self, forCellReuseIdentifier: cellID)
        fetchData()
        tableView.rowHeight = 130
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        guard let cell = cell as? FriendViewCell else { return UITableViewCell() }
        
        cell.selectionStyle = .none
        let item = items[indexPath.row]
        cell.configure(with: item)
        
        return cell
    }
    
    private func fetchData() {
        let friendURL = URL(string: "https://api.vk.com/method/friends.get?user_ids=\(userID ?? "")&fields=bdays,city,photo_100,online&access_token=\(token ?? "")&v=5.131")!
        
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
