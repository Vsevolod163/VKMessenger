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
    let items: [Int]
}
