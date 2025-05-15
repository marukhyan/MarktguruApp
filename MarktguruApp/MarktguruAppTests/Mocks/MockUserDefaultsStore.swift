//
//  MockUserDefaultsStore.swift
//  MarktguruApp
//
//  Created by Davit Marukhyan on 15.05.25.
//

@testable import MarktguruApp

final class MockUserDefaultsStore: UserDefaultsStoreProtocol {
    var mockIsDarkMode: Bool = false
    var favorites: Set<Int> = []
    
    var isDarkMode: Bool {
        get { mockIsDarkMode }
        set { mockIsDarkMode = newValue }
    }
    
    func toggleFavorite(for productId: Int) {
        if favorites.contains(productId) {
            favorites.remove(productId)
        } else {
            favorites.insert(productId)
        }
    }
    
    func isFavorite(_ productId: Int) -> Bool {
        favorites.contains(productId)
    }
    
    func getFavorites() -> [Int] {
        Array(favorites)
    }
}
