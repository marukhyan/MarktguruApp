//
//  MockNetworkManager.swift
//  MarktguruApp
//
//  Created by Davit Marukhyan on 15.05.25.
//

@testable import MarktguruApp

final class MockNetworkManager: NetworkManagerProtocol {
    var mockResult: Any?
    var mockError: Error?
    var capturedRequest: RequestProtocol?
    var capturedBaseURL: String?
    
    func execute<T: Decodable>(_ request: RequestProtocol, baseURL: String) async throws -> T {
        capturedRequest = request
        capturedBaseURL = baseURL
        
        if let error = mockError {
            throw error
        }
        
        guard let result = mockResult as? T else {
            throw NetworkError.decodingError
        }
        
        return result
    }
}
