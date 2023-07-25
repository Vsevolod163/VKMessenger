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
    private let storageManager = StorageManager.shared
    
    private var groups: [GroupItem] = []
    private var allGroups: [Group] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(GroupViewCell.self, forCellReuseIdentifier: cellID)
        fetchData()
        tableView.rowHeight = 130
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        groups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        guard let cell = cell as? GroupViewCell else { return UITableViewCell() }
        
        cell.selectionStyle = .none
        cell.backgroundColor = Interface.cellColor
        let group = allGroups[indexPath.row]
        cell.configure(with: group)
        
        return cell
    }
    
    private func fetchData() {
        let groupUrl = URL(string: "https://api.vk.com/method/groups.get?user_id=\(NetworkManager.userID)&extended=1&fields=description&access_token=\(NetworkManager.token)&v=5.131")!
        
        networkManager.fetch(GroupResponse.self, from: groupUrl) { [weak self] result in
            switch result {
            case .success(let group):
                self?.groups = group.response.items
                self?.fetchGroups()
                
                self?.allGroups.forEach { group in
                    self?.storageManager.deleteGroup(group)
                }
                
                self?.allGroups = []
                
                self?.groups.forEach { group in
                    self?.storageManager.createGroup(
                        id: group.id,
                        name: group.name,
                        groupDescription: group.description,
                        photoTwoHundred: group.photoOneHundred
                    )
                }
                
                self?.fetchGroups()
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func fetchGroups() {
        storageManager.fetchGroups { result in
            switch result {
            case .success(let groups):
                allGroups = groups
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
