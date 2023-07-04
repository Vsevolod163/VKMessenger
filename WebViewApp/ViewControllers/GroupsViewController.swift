//
//  GroupsViewController.swift
//  WebViewApp
//
//  Created by Vsevolod Lashin on 03.07.2023.
//

import UIKit

final class GroupsViewController: UITableViewController {
    
    var token: String!
    var userID: String!
    
    private let networkManager = NetworkManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        fetchData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */
    
    private func fetchData() {
        let groupUrl = URL(string: "https://api.vk.com/method/groups.get?user_ids=\(userID ?? "")&access_token=\(token ?? "")&v=5.131")!
        
        networkManager.fetch(FriendResponse.self, from: groupUrl) { result in
            switch result {
            case .success(let group):
                print(group.response.items)
            case .failure(let error):
                print(error)
            }
        }
    }
}
