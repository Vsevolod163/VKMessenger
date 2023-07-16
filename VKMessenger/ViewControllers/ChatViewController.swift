//
//  ChatViewController.swift
//  WebViewApp
//
//  Created by Vsevolod Lashin on 15.07.2023.
//

import UIKit
import CoreData

final class ChatViewController: UIViewController {

    var id: Int!
    
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
    
    private lazy var messageTF: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Message"
        textField.borderStyle = .roundedRect
        
        return textField
    }()
    
    private lazy var messagesTableView: UITableView = {
        let tableView = UITableView()
        
        return tableView
    }()
    
    private lazy var sendButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.up"), for: .normal)
        button.backgroundColor = .orange
        button.imageView?.tintColor = .white
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        let action = UIAction { [weak self] _ in
            self?.sendButtonPressed()
        }
        button.addAction(action, for: .touchUpInside)
        
        return button
    }()
    
    private var allChats: [Chat]!
    private var currentChat: Chat!
    private var items: [User] = []
    private let storageManager = StorageManager.shared
    private let networkManager = NetworkManager.shared
    private let cellID = "message"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        navigationController?.navigationBar.tintColor = .white

        storageManager.fetchData { result in
            switch result {
            case .success(let chats):
                allChats = chats
            case .failure(let failure):
                print(failure)
            }
        }
        
        checkChat()
        fetchChats()
        fetchData()
        
        setupSubviews(userImage, nameLabel, messageTF, messagesTableView, sendButton)
        setConstraints()
        messagesTableView.dataSource = self
        messagesTableView.register(ChatViewCell.self, forCellReuseIdentifier: cellID)
    }
    
    private func sendButtonPressed() {
        
    }
    
    private func setupSubviews(_ subviews: UIView...) {
        subviews.forEach { subview in
            view.addSubview(subview)
        }
    }
    
    private func setConstraints() {
        userImage.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        messageTF.translatesAutoresizingMaskIntoConstraints = false
        messagesTableView.translatesAutoresizingMaskIntoConstraints = false
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [
                userImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
                userImage.widthAnchor.constraint(equalToConstant: 150),
                userImage.heightAnchor.constraint(equalToConstant: 150),
                userImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                
                nameLabel.topAnchor.constraint(equalTo: userImage.bottomAnchor, constant: 20),
                nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                
                messageTF.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                messageTF.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -8),
                messageTF.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20),
                
                sendButton.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20),
                sendButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                sendButton.widthAnchor.constraint(equalToConstant: 40),
                sendButton.heightAnchor.constraint(equalTo: messageTF.heightAnchor, multiplier: 1),
                
                messagesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                messagesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                messagesTableView.topAnchor.constraint(equalTo: messageTF.bottomAnchor, constant: 8),
                messagesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ]
        )
    }
    
    private func fetchData() {
        let url = "https://api.vk.com/method/users.get?user_ids=\(id ?? 0)&fields=city,online,photo_200&access_token=\(NetworkManager.token)&v=5.131"
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
    
    
    private func checkChat() {
        for chat in allChats {
            if chat.id == id {
                currentChat = chat
                storageManager.update(chat, message: "New")
                print(chat.messages ?? [])
                return
            }
            print(chat.id)
        }
    
        storageManager.create(id: id, messages: ["Hello", "How are you?"])
        fetchChats()
        
        for chat in allChats {
            if chat.id == id {
                currentChat = chat
            }
        }
    }
    
    private func fetchChats() {
        storageManager.fetchData { result in
            switch result {
            case .success(let chats):
                allChats = chats
            case .failure(let error):
                print(error)
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if currentChat == nil {
            return 0
        } else {
            return currentChat.messages?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        guard let cell = cell as? ChatViewCell else { return UITableViewCell() }
        
        let message = currentChat.messages?[indexPath.row] ?? ""
        cell.configure(with: message)
        
        return cell
    }
    
    
}
