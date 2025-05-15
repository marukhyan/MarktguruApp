//
//  ProductsServiceTests.swift
//  MarktguruApp
//
//  Created by Davit Marukhyan on 15.05.25.
//

import XCTest
@testable import MarktguruApp

final class ProductsServiceTests: XCTestCase {
    var sut: ProductsService!
    var mockNetworkManager: MockNetworkManager!
    
    override func setUp() {
        super.setUp()
        mockNetworkManager = MockNetworkManager()
        sut = ProductsService(networkManager: mockNetworkManager)
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testFetchProducts_Success_ReturnsProducts() async throws {
        // Given
        let mockProducts = [
            ProductModel(id: 1, title: "Product 1",
                         price: 10.0, description: "Description 1",
                         images: ["image1"]),
            ProductModel(id: 2,
                         title: "Product 2",
                         price: 20.0,
                         description: "Description 2",
                         images: ["image2"])
        ]
        mockNetworkManager.mockResult = mockProducts
        
        // When
        let result = try await sut.fetchProducts(offset: 0, limit: 10)
        
        // Then
        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result[0].id, 1)
        XCTAssertEqual(result[1].id, 2)
    }
    
    func testFetchProducts_NetworkError_ThrowsError() async {
        // Given
        mockNetworkManager.mockError = NetworkError.networkUnknownError
        
        // When/Then
        do {
            _ = try await sut.fetchProducts(offset: 0, limit: 10)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as? NetworkError, NetworkError.networkUnknownError)
        }
    }
    
    func testFetchProducts_VerifyRequestParameters() async throws {
        // Given
        let offset = 20
        let limit = 15
        mockNetworkManager.mockResult = [ProductModel]()
        
        // When
        _ = try await sut.fetchProducts(offset: offset, limit: limit)
        
        // Then
        let capturedRequest = mockNetworkManager.capturedRequest as? GetProductsRequest
        XCTAssertNotNil(capturedRequest)
        XCTAssertEqual(capturedRequest?.offset, offset)
        XCTAssertEqual(capturedRequest?.limit, limit)
    }
}
