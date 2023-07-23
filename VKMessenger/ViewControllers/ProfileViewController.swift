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
        label.textColor = Interface.textColor
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var firstThemeButton: UIButton = {
        let button = UIButton()
        let action = UIAction { [weak self] _ in
            Interface.viewColor = .white
            Interface.cellColor = .white
            Interface.textColor = .black
            self?.setupButton()
        }
        button.setTitleColor(Interface.textColor, for: .normal)
        button.setTitle("White Interface", for: .normal)
        button.addAction(action, for: .touchUpInside)
        
        return button
    }()
    
    private lazy var secondThemeButton: UIButton = {
        let button = UIButton()
        let action = UIAction { [weak self] _ in
            Interface.viewColor = .black
            Interface.cellColor = .black
            Interface.textColor = .white
            self?.setupButton()
        }
        button.setTitleColor(Interface.textColor, for: .normal)
        button.setTitle("Black Interface", for: .normal)
        button.addAction(action, for: .touchUpInside)
        
        return button
    }()
    
    private lazy var thirdThemeButton: UIButton = {
        let button = UIButton()
        let action = UIAction { [weak self] _ in
            Interface.viewColor = .systemOrange
            Interface.cellColor = .systemOrange
            Interface.textColor = .yellow
            self?.setupButton()
        }
        button.setTitleColor(Interface.textColor, for: .normal)
        button.setTitle("Orange Interface", for: .normal)
        button.addAction(action, for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Interface.viewColor
        navigationController?.navigationBar.tintColor = Interface.textColor
        setupSubviews(userImage, nameLabel, firstThemeButton, secondThemeButton, thirdThemeButton)
        setConstraints()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userImage.pulsate()
        nameLabel.pulsate()
    }
    
    private func setupButton() {
        nameLabel.textColor = Interface.textColor
        view.backgroundColor = Interface.viewColor
        firstThemeButton.setTitleColor(Interface.textColor, for: .normal)
        secondThemeButton.setTitleColor(Interface.textColor, for: .normal)
        thirdThemeButton.setTitleColor(Interface.textColor, for: .normal)
        navigationController?.navigationBar.tintColor = Interface.textColor
        
        tabBarController?.viewControllers?.forEach { viewController in
            if let groupVC = viewController as? GroupsViewController {
                groupVC.view.backgroundColor = Interface.viewColor
                groupVC.tableView.reloadData()
            } else if let photoVC = viewController as? PhotosViewController {
                photoVC.collectionView.backgroundColor = Interface.viewColor
                photoVC.collectionView.reloadData()
            } else if let navigationVC = viewController as? UINavigationController {
                navigationVC.viewControllers.forEach { viewController in
                    if let friendsVC = viewController as? FriendsViewController {
                        friendsVC.view.backgroundColor = Interface.viewColor
                        friendsVC.navigationItem.rightBarButtonItem?.tintColor = Interface.textColor
                        friendsVC.tableView.reloadData()
                    }
                }
            }
        }
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
        firstThemeButton.translatesAutoresizingMaskIntoConstraints = false
        secondThemeButton.translatesAutoresizingMaskIntoConstraints = false
        thirdThemeButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [
                userImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
                userImage.widthAnchor.constraint(equalToConstant: 150),
                userImage.heightAnchor.constraint(equalToConstant: 150),
                userImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                
                nameLabel.topAnchor.constraint(equalTo: userImage.bottomAnchor, constant: 20),
                nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                
                firstThemeButton.bottomAnchor.constraint(equalTo: secondThemeButton.topAnchor, constant: -20),
                firstThemeButton.widthAnchor.constraint(equalTo: userImage.widthAnchor, multiplier: 1),
                firstThemeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                
                secondThemeButton.bottomAnchor.constraint(equalTo: thirdThemeButton.topAnchor, constant: -20),
                secondThemeButton.widthAnchor.constraint(equalTo: userImage.widthAnchor, multiplier: 1),
                secondThemeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                
                thirdThemeButton.topAnchor.constraint(equalTo: view.centerYAnchor, constant: 150),
                thirdThemeButton.widthAnchor.constraint(equalTo: userImage.widthAnchor, multiplier: 1),
                thirdThemeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ]
        )
    }
}



