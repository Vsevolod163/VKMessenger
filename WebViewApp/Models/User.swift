//
//  User.swift
//  WebViewApp
//
//  Created by Vsevolod Lashin on 14.07.2023.
//

struct UserResponse: Decodable {
    let response: [User]
}

struct User: Decodable {
    let photo_100: String
    let first_name: String
    let last_name: String
}
