//
//  GetProductsRequest.swift
//  MarktguruApp
//
//  Created by Davit Marukhyan on 15.05.25.
//

import Foundation

struct GetProductsRequest: RequestProtocol {
    let offset: Int
    let limit: Int
    
    var path: String { "/products" }
    
    var method: HTTPMethod { .get }
    
    var queryItems: [URLQueryItem]? {
        [
            URLQueryItem(name: "offset", value: String(offset)),
            URLQueryItem(name: "limit", value: String(limit))
        ]
    }
    
    var headers: [String: String]? {
        ["Content-Type": "application/json"]
    }
}
