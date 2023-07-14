//
//  ProfileViewController.swift
//  WebViewApp
//
//  Created by Vsevolod Lashin on 14.07.2023.
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    
    private let networkManager = NetworkManager.shared
    private var items: [User] = []
    
    private lazy var userImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        navigationController?.navigationBar.tintColor = .white
        setupSubviews(userImage, nameLabel)
        setConstraints()
        fetchData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userImage.pulsate()
        nameLabel.pulsate()
    }
    
    private func fetchData() {
        let url = "https://api.vk.com/method/users.get?user_ids=\(NetworkManager.userID)&fields=city,online,photo_200&access_token=\(NetworkManager.token)&v=5.131"
        guard let url = URL(string: url) else { return }
        
        networkManager.fetch(UserResponse.self, from: url) { [weak self] result in
            switch result {
            case .success(let response):
                self?.items = response.response
                
                self?.userImage.kf.setImage(with: URL(string: self?.items.first?.photoTwoHundred ?? ""))
                self?.nameLabel.text = "\(self?.items.first?.firstName ?? "ыппыпывпыв") \(self?.items.first?.lastName ?? "")"
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func setupSubviews(_ subviews: UIView...) {
        subviews.forEach { subview in
            view.addSubview(subview)
        }
    }
    
    private func setConstraints() {
        userImage.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [
                userImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
                userImage.widthAnchor.constraint(equalToConstant: 150),
                userImage.heightAnchor.constraint(equalToConstant: 150),
                userImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                
                nameLabel.topAnchor.constraint(equalTo: userImage.bottomAnchor, constant: 20),
                nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
            ]
        )
    }
}



