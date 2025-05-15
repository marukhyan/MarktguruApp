//
//  UserDefaultsStore.swift
//  MarktguruApp
//
//  Created by Davit Marukhyan on 15.05.25.
//

import SwiftUI

protocol UserDefaultsStoreProtocol {
    var isDarkMode: Bool { get set }
    func toggleFavorite(for productId: Int)
    func isFavorite(_ productId: Int) -> Bool
    func getFavorites() -> [Int]
}

final class UserDefaultsStore: UserDefaultsStoreProtocol {
    static let shared = UserDefaultsStore()
    
    private init() {}
    
    @UserDefault("isDarkMode", defaultValue: false)
    var isDarkMode: Bool
    
    private let favoritesKey = "favoriteProducts"
    
    func toggleFavorite(for productId: Int) {
        var favorites = getFavorites()
        if favorites.contains(productId) {
            favorites.removeAll { $0 == productId }
        } else {
            favorites.append(productId)
        }
        UserDefaults.standard.set(favorites, forKey: favoritesKey)
    }
    
    func isFavorite(_ productId: Int) -> Bool {
        getFavorites().contains(productId)
    }
    
    func getFavorites() -> [Int] {
        UserDefaults.standard.array(forKey: favoritesKey) as? [Int] ?? []
    }
}

@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T
    
    init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: T {
        get {
            UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}
