//
//  ProductsService.swift
//  MarktguruApp
//
//  Created by Davit Marukhyan on 15.05.25.
//

import Foundation

protocol ProductServiceProtocol {
    func fetchProducts(offset: Int, limit: Int) async throws -> [ProductModel]
}

final class ProductsService: ProductServiceProtocol {
    static let shared = ProductsService()
    
    private let baseURL = "https://api.escuelajs.co/api/v1"
    private let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    func fetchProducts(offset: Int, limit: Int = 10) async throws -> [ProductModel] {
        let request = GetProductsRequest(offset: offset, limit: limit)
        return try await networkManager.execute(request, baseURL: baseURL)
    }
}
