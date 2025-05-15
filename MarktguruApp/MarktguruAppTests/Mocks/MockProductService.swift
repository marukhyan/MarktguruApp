//
//  MockProductService.swift
//  MarktguruApp
//
//  Created by Davit Marukhyan on 15.05.25.
//

@testable import MarktguruApp

final class MockProductService: ProductServiceProtocol {
    var mockProducts: [ProductModel] = []
    var mockError: Error?
    var capturedOffset: Int?
    var capturedLimit: Int?
    
    func fetchProducts(offset: Int, limit: Int) async throws -> [ProductModel] {
        capturedOffset = offset
        capturedLimit = limit
        
        if let error = mockError {
            throw error
        }
        
        return mockProducts
    }
}
