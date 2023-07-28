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
    let photoTwoHundred: String
    let firstName: String
    let lastName: String

    enum CodingKeys: String, CodingKey {
        case photoTwoHundred = "photo_200"
        case firstName = "first_name"
        case lastName = "last_name"
    }
}
