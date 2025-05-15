//
//  NetworkManager.swift
//  MarktguruApp
//
//  Created by Davit Marukhyan on 15.05.25.
//

import Foundation

protocol NetworkManagerProtocol {
    func execute<T: Decodable>(_ request: RequestProtocol,
                               baseURL: String) async throws -> T
}

final class NetworkManager: NetworkManagerProtocol {
    static let shared = NetworkManager()
    private let session: URLSession
    private let decoder: JSONDecoder
    
    init(session: URLSession = .shared,
         decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.decoder = decoder
    }
    
    func execute<T: Decodable>(_ request: RequestProtocol,
                               baseURL: String) async throws -> T {
        guard var urlComponents = URLComponents(string: baseURL) else {
            throw NetworkError.invalidURL
        }
        
        urlComponents.path += request.path.hasPrefix("/") ? request.path : "/" + request.path
        
        if let queryItems = request.queryItems {
            urlComponents.queryItems = queryItems
        }
        
        guard let url = urlComponents.url else {
            throw NetworkError.invalidURL
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        
        request.headers?.forEach { key, value in
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        
        #if DEBUG
        print("\n REQUEST:")
        print("URL: \(urlRequest.url?.absoluteString ?? "")")
        print("Method: \(urlRequest.httpMethod ?? "")")
        print("Headers: \(urlRequest.allHTTPHeaderFields ?? [:])")
        if let queryItems = request.queryItems {
            print("Query Items: \(queryItems)")
        }
        #endif
        do {
            let (data, response) = try await session.data(for: urlRequest)
            
            #if DEBUG
            print("\n📥 RESPONSE:")
            print("Status: \((response as? HTTPURLResponse)?.statusCode ?? 0)")
            if let jsonObject = try? JSONSerialization.jsonObject(with: data),
               let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
               let prettyPrintedString = String(data: jsonData, encoding: .utf8) {
                print("Body: \(prettyPrintedString)")
            }
            #endif
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.invalidResponse
            }
            
            do {
                return try decoder.decode(T.self, from: data)
            } catch {
                throw NetworkError.decodingError
            }
        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.networkUnknownError
        }
    }
}

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case decodingError
    case networkUnknownError
}
