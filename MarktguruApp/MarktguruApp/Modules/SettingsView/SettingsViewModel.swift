//
//  SettingsViewModel.swift
//  MarktguruApp
//
//  Created by Davit Marukhyan on 15.05.25.
//

import SwiftUI

class SettingsViewModel: ObservableObject {
    @Published var isDarkMode: Bool {
        didSet {
            ThemeManager.shared.isDarkMode = isDarkMode
        }
    }
    
    private let userDefaultsStore: UserDefaultsStore
    
    init(userDefaultsStore: UserDefaultsStore = .shared) {
        self.userDefaultsStore = userDefaultsStore
        self.isDarkMode = userDefaultsStore.isDarkMode
    }
}
