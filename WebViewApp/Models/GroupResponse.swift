//
//  GroupResponse.swift
//  WebViewApp
//
//  Created by Vsevolod Lashin on 04.07.2023.
//

struct GroupResponse: Decodable {
    let response: Groups
}

struct Groups: Decodable {
    let count: Int
    let items: [Group]
}

struct Group: Decodable {
    let id: String
    let description: String
    let name: String
    let photoOneHundred: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case description
        case name
        case photoOneHundred = "photo_100"
    }
}
