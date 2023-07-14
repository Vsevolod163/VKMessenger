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
    let photoOneHundred: String?
    let firstName: String?
    let lastName: String?
    let online: Int
    
    enum CodingKeys: String, CodingKey {
        case city
        case photoOneHundred = "photo_100"
        case firstName = "first_name"
        case lastName = "last_name"
        case online
    }
}

struct City: Decodable {
    let title: String
}

