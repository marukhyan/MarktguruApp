//
//  ImageCache.swift
//  MarktguruApp
//
//  Created by Davit Marukhyan on 15.05.25.
//

import SwiftUI

final class ImageCache {
    static let shared = ImageCache()
    private let cache = NSCache<NSURL, UIImage>()
    
    private init() {
        cache.countLimit = 100
        cache.totalCostLimit = 50 * 1024 * 1024 // 50MB
    }
    
    func object(forKey key: NSURL) -> UIImage? {
        return cache.object(forKey: key)
    }
    
    func setObject(_ obj: UIImage, forKey key: NSURL) {
        cache.setObject(obj, forKey: key)
    }
}
