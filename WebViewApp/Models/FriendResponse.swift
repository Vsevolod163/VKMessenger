//
//  Friend.swift
//  WebViewApp
//
//  Created by Vsevolod Lashin on 04.07.2023.
//

struct FriendResponse: Decodable {
    let response: Response
}

struct Response: Decodable {
    let count: Int
    let items: [Item]
}

struct Item: Decodable {
    let city: City?
    let photo_100: String
    let first_name: String
    let last_name: String
    
}

struct City: Decodable {
    let title: String
}
