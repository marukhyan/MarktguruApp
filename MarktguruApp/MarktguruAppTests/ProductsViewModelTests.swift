//
//  ProductsViewModelTests.swift
//  MarktguruApp
//
//  Created by Davit Marukhyan on 15.05.25.
//

import XCTest
@testable import MarktguruApp

@MainActor
final class ProductsViewModelTests: XCTestCase {
    var sut: ProductsViewModel!
    var mockProductService: MockProductService!
    var mockUserDefaultsStore: MockUserDefaultsStore!
    
    override func setUp() {
        super.setUp()
        mockProductService = MockProductService()
        mockUserDefaultsStore = MockUserDefaultsStore()
        sut = ProductsViewModel(productService: mockProductService,
                              userDefaultsStore: mockUserDefaultsStore)
    }
    
    override func tearDown() {
        sut = nil
        mockProductService = nil
        mockUserDefaultsStore = nil
        super.tearDown()
    }
    
    func testLoadInitialProducts_Success_UpdatesProducts() async {
        // Given
        let mockProducts = [
            ProductModel(id: 1,
                         title: "Product 1",
                         price: 10.0,
                         description: "Description 1",
                         images: ["image1"]),
            ProductModel(id: 2,
                         title: "Product 2",
                         price: 20.0,
                         description: "Description 2",
                         images: ["image2"])
        ]
        mockProductService.mockProducts = mockProducts
        
        // When
        await sut.loadInitialProducts()
        
        // Then
        XCTAssertEqual(sut.products.count, 2)
        XCTAssertEqual(sut.products[0].id, 1)
        XCTAssertEqual(sut.products[1].id, 2)
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.error)
    }
    
    func testLoadInitialProducts_Error_SetsError() async {
        // Given
        mockProductService.mockError = NetworkError.networkUnknownError
        
        // When
        await sut.loadInitialProducts()
        
        // Then
        XCTAssertTrue(sut.products.isEmpty)
        XCTAssertFalse(sut.isLoading)
        XCTAssertNotNil(sut.error)
    }
    
    func testLoadMoreProducts_Success_AppendsProducts() async {
        // Given
        let initialProducts = [
            ProductModel(id: 1,
                         title: "Product 1",
                         price: 10.0,
                         description: "Description 1",
                         images: ["image1"])
        ]
        sut.products = initialProducts
        
        let newProducts = [
            ProductModel(id: 2,
                         title: "Product 2",
                         price: 20.0,
                         description: "Description 2",
                         images: ["image2"])
        ]
        mockProductService.mockProducts = newProducts
        
        // When
        await sut.loadMoreProducts()
        
        // Then
        XCTAssertEqual(sut.products.count, 2)
        XCTAssertEqual(sut.products[0].id, 1)
        XCTAssertEqual(sut.products[1].id, 2)
    }
    
    func testToggleFavorite_UpdatesFavorites() {
        // Given
        let product = ProductModel(id: 1,
                                   title: "Product",
                                   price: 10.0,
                                   description: "Description",
                                   images: ["image"])
        
        // When
        sut.toggleFavorite(for: product)
        
        // Then
        XCTAssertTrue(sut.isFavorite(product))
        XCTAssertTrue(mockUserDefaultsStore.favorites.contains(product.id))
        
        // When toggling again
        sut.toggleFavorite(for: product)
        
        // Then
        XCTAssertFalse(sut.isFavorite(product))
        XCTAssertFalse(mockUserDefaultsStore.favorites.contains(product.id))
    }
    
    func testShouldLoadMore_ReturnsTrue_WhenNearEnd() {
        // Given
        let products = (0...10).map { id in
            ProductModel(id: id,
                         title: "Product \(id)",
                         price: Double(id),
                         description: "Description \(id)",
                         images: ["image\(id)"])
        }
        sut.products = products
        let lastProduct = products[9] // Second to last product
        
        // When
        let shouldLoadMore = sut.shouldLoadMore(for: lastProduct)
        
        // Then
        XCTAssertTrue(shouldLoadMore)
    }
    
    func testShouldLoadMore_ReturnsFalse_WhenNotNearEnd() {
        // Given
        let products = (0...10).map { id in
            ProductModel(id: id,
                         title: "Product \(id)",
                         price: Double(id),
                         description: "Description \(id)",
                         images: ["image\(id)"])
        }
        sut.products = products
        let middleProduct = products[5]
        
        // When
        let shouldLoadMore = sut.shouldLoadMore(for: middleProduct)
        
        // Then
        XCTAssertFalse(shouldLoadMore)
    }
}
