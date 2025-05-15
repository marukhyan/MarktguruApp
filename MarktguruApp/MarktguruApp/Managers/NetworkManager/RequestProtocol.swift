//
//  RequestProtocol.swift
//  MarktguruApp
//
//  Created by Davit Marukhyan on 15.05.25.
//

import Foundation

protocol RequestProtocol {
    var path: String { get }
    var method: HTTPMethod { get }
    var queryItems: [URLQueryItem]? { get }
    var headers: [String: String]? { get }
}

enum HTTPMethod: String {
    case get = "GET"
}
