//
//  PhotosViewController.swift
//  WebViewApp
//
//  Created by Vsevolod Lashin on 03.07.2023.
//

import UIKit

final class PhotosViewController: UICollectionViewController {

    private let cellID = "photo"
    private let networkManager = NetworkManager.shared
    private let itemsPerRow: CGFloat = 2
    private let sectionsInserts = UIEdgeInsets(top: 20, left: 16, bottom: 20, right: 16)
    private var photos: [PhotoItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView!.register(PhotoViewCell.self, forCellWithReuseIdentifier: cellID)
        fetchData()
    }
    
    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
        guard let cell = cell as? PhotoViewCell else {
            return UICollectionViewCell()
        }
        
        let photo = photos[indexPath.row].sizes.last?.url ?? ""
        cell.configure(with: photo)
        
        return cell
    }
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        let flowLayout = UICollectionViewFlowLayout()
        super.init(collectionViewLayout: flowLayout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func fetchData() {
        let photoUrl = URL(string: "https://api.vk.com/method/photos.getAll?user_ids=\(NetworkManager.userID)&access_token=\(NetworkManager.token)&v=5.131")!
        
        networkManager.fetch(PhotoResponse.self, from: photoUrl) { [weak self] result in
            switch result {
            case .success(let photo):
                self?.photos = photo.response.items
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

// MARK: UICollecionViewDelegateFlowLayout
extension PhotosViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingWidth = sectionsInserts.left * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingWidth
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        sectionsInserts
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        sectionsInserts.left
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        sectionsInserts.left
    }
}
