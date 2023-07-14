//
//  ChatViewController.swift
//  WebViewApp
//
//  Created by Vsevolod Lashin on 15.07.2023.
//

import UIKit

final class ChatViewController: UIViewController {

    var id: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        navigationController?.navigationBar.tintColor = .white
        print(id)
    }
}
