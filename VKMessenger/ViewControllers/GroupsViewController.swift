//
//  GroupsViewController.swift
//  WebViewApp
//
//  Created by Vsevolod Lashin on 03.07.2023.
//

import UIKit

final class GroupsViewController: UITableViewController {
    
    private let cellID = "group"
    private let networkManager = NetworkManager.shared
    private var groups: [Group] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(GroupViewCell.self, forCellReuseIdentifier: cellID)
        fetchData()
        tableView.rowHeight = 130
        tableView.backgroundColor = .black
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        groups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        guard let cell = cell as? GroupViewCell else { return UITableViewCell() }
        
        cell.selectionStyle = .none
        cell.backgroundColor = .black
        let group = groups[indexPath.row]
        cell.configure(with: group)
        
        return cell
    }
    
    private func fetchData() {
        let groupUrl = URL(string: "https://api.vk.com/method/groups.get?user_id=\(NetworkManager.userID)&extended=1&fields=description&access_token=\(NetworkManager.token)&v=5.131")!
        
        networkManager.fetch(GroupResponse.self, from: groupUrl) { [weak self] result in
            switch result {
            case .success(let group):
                self?.groups = group.response.items
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
