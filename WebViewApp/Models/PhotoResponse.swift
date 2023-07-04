//
//  Photo.swift
//  WebViewApp
//
//  Created by Vsevolod Lashin on 04.07.2023.
//

struct PhotoResponse: Decodable {
    let response: Photos
}

struct Photos: Decodable {
    let count: Int
    let items: [Photo]
}

struct Photo: Decodable {
    let sizes: [Size]
}

struct Size: Decodable{
    let type: String
    let url: String
}
