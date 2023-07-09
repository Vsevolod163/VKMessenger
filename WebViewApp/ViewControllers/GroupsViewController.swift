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
        fetchData()
    }
    
    private func fetchData() {
        let groupUrl = URL(string: "https://api.vk.com/method/groups.get?user_id=\(userID ?? "")&extended=1&fields=description&access_token=\(token ?? "")&v=5.131")!
        
        networkManager.fetch(GroupResponse.self, from: groupUrl) { result in
            switch result {
            case .success(let group):
                print(group.response.items)
            case .failure(let error):
                print(error)
            }
        }
    }
}
