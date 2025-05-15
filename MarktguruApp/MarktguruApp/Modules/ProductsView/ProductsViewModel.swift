//
//  ProductsViewModel.swift
//  MarktguruApp
//
//  Created by Davit Marukhyan on 15.05.25.
//
import SwiftUI

@MainActor
final class ProductsViewModel: ObservableObject {
    @Published var products: [ProductModel] = []
    @Published var isLoading = false
    @Published var error: Error?
    @Published private(set) var favoriteProductIds: Set<Int> = []
    
    private var currentOffset = 0
    private let limit = 10
    
    private let productService: ProductServiceProtocol
    private let userDefaultsStore: UserDefaultsStoreProtocol
    
    init(productService: ProductServiceProtocol = ProductsService.shared,
         userDefaultsStore: UserDefaultsStoreProtocol = UserDefaultsStore.shared) {
        self.productService = productService
        self.userDefaultsStore = userDefaultsStore
        self.favoriteProductIds = Set(userDefaultsStore.getFavorites())
    }
    
    func loadInitialProducts() async {
        guard products.isEmpty else { return }
        await loadMoreProducts()
    }
    
    func loadMoreProducts() async {
        guard !isLoading else { return }
        
        isLoading = true
        error = nil
        
        do {
            let newProducts = try await productService.fetchProducts(offset: currentOffset, limit: limit)
            products.append(contentsOf: newProducts)
            currentOffset += newProducts.count
        } catch {
            self.error = error
        }
        
        isLoading = false
    }
    
    func toggleFavorite(for product: ProductModel) {
        userDefaultsStore.toggleFavorite(for: product.id)
        if favoriteProductIds.contains(product.id) {
            favoriteProductIds.remove(product.id)
        } else {
            favoriteProductIds.insert(product.id)
        }
        objectWillChange.send()
    }
    
    func isFavorite(_ product: ProductModel) -> Bool {
        favoriteProductIds.contains(product.id)
    }
    
    func shouldLoadMore(for product: ProductModel) -> Bool {
        // Load more when we're 2 items away from the end
        guard let index = products.firstIndex(where: { $0.id == product.id }) else { return false }
        return index >= products.count - 2
    }
}
