//
//  ThemeManager.swift
//  MarktguruApp
//
//  Created by Davit Marukhyan on 15.05.25.
//

import SwiftUI

final class ThemeManager: ObservableObject {
    static let shared = ThemeManager()
    
    private let userDefaultsStore: UserDefaultsStore
    
    private init() {
        self.userDefaultsStore = UserDefaultsStore.shared
        self.isDarkMode = userDefaultsStore.isDarkMode
    }
    
    @Published var isDarkMode: Bool {
        didSet {
            userDefaultsStore.isDarkMode = isDarkMode
        }
    }
}
