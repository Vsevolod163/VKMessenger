//
//  NetworkManager.swift
//  WebViewApp
//
//  Created by Vsevolod Lashin on 04.07.2023.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

final class NetworkManager {
    static var shared = NetworkManager()
    
    private init() {}
    
    func fetch(from url: URL, completion: @escaping (Result<Response, NetworkError>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data else {
                completion(.failure(.noData))
                print(error?.localizedDescription ?? "No error description")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let dataModel = try decoder.decode(Response.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(dataModel))
                }
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
}
