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
    
    private var allChats: [Chat]!
    private let storageManager = StorageManager.shared
    
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
    }
    
    private func checkChat() {
        for chat in allChats {
            if chat.id == id {
                storageManager.update(chat, message: "New")
                print(chat.messages ?? [])
                return
            }
            print(chat.id)
        }
    
        storageManager.create(id: id, messages: ["Hello", "How are you?"])
    }
}
