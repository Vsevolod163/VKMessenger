//
//  PhotosViewController.swift
//  WebViewApp
//
//  Created by Vsevolod Lashin on 03.07.2023.
//

import UIKit

final class PhotosViewController: UICollectionViewController {
    
    var token: String!
    var userID: String!
    
    private let networkManager = NetworkManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    }
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        let flowLayout = UICollectionViewFlowLayout()
        super.init(collectionViewLayout: flowLayout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func fetchData() {
        let groupUrl = URL(string: "https://api.vk.com/method/photos.getAll?user_ids=\(userID ?? "")&access_token=\(token ?? "")&v=5.131")!
        
        networkManager.fetch(PhotoResponse.self, from: groupUrl) { result in
            switch result {
            case .success(let group):
                print(group.response.items)
            case .failure(let error):
                print(error)
            }
        }
    }
}
