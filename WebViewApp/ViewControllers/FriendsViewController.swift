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
    private var friendResponse = FriendResponse(
        response: Response(
            count: 1, items: [
                Item(
                    city: City(title: ""),
                    photo_100: "",
                    first_name: "",
                    last_name: ""
                )
            ]
        )
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        view.backgroundColor = .black
        tableView.register(FriendViewCell.self, forCellReuseIdentifier: cellID)
        tableView.rowHeight = 130
        tableView.separatorStyle = .none
    }

    // MARK: - TableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        friendResponse.response.items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        guard let cell = cell as? FriendViewCell else { return UITableViewCell() }
        
        let friend = friendResponse.response.items[indexPath.row]
        cell.configure(withPhoto: friend.photo_100, andName: "\(friend.first_name) \(friend.last_name)")
        cell.backgroundColor = .black
        cell.selectionStyle = .none
        
        return cell
    }
    
    private func fetchData() {
        let friendURL = URL(string: "https://api.vk.com/method/friends.get?user_ids=\(userID ?? "")&fields=bdays,city,photo_100&access_token=\(token ?? "")&v=5.131")!
        
        networkManager.fetch(FriendResponse.self, from: friendURL) { [weak self] result in
            switch result {
            case .success(let response):
                self?.friendResponse = response
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }

}
