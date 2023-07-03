//
//  Friend.swift
//  WebViewApp
//
//  Created by Vsevolod Lashin on 04.07.2023.
//

struct Response: Decodable {
    let response: Friend
}

struct Friend: Decodable {
    let count: Int
    let items: [Int]
}
