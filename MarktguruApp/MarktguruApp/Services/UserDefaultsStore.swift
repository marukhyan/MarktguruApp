//
//  UserDefaultsStore.swift
//  MarktguruApp
//
//  Created by Davit Marukhyan on 15.05.25.
//

import SwiftUI

protocol UserDefaultsStoreProtocol {
    var isDarkMode: Bool { get set }
}

class UserDefaultsStore: UserDefaultsStoreProtocol {
    static let shared = UserDefaultsStore()
    
    private init() {}
    
    @UserDefault("isDarkMode", defaultValue: false)
    var isDarkMode: Bool
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
