//
//  ImageLoader.swift
//  MarktguruApp
//
//  Created by Davit Marukhyan on 15.05.25.
//

import SwiftUI

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    @Published var isLoading = false
    @Published var error: Error?
    
    private var url: URL?
    private var task: URLSessionDataTask?
    private let session: URLSession
    private let cache: ImageCache
    
    init(session: URLSession = .shared,
         cache: ImageCache = .shared) {
        self.session = session
        self.cache = cache
    }
    
    func load(url: URL?) {
        guard let url = url else {
            self.error = NSError(domain: "ImageLoader",
                                 code: -1,
                                 userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
            return
        }
        
        self.url = url
        self.image = nil
        self.error = nil
        
        if let cachedImage = cache.object(forKey: url as NSURL) {
            self.image = cachedImage
            return
        }
        
        isLoading = true
        
        task?.cancel()
        
        task = session.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                guard let self = self, self.url == url else { return }
                
                self.isLoading = false
                
                if let error = error {
                    self.error = error
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    self.error = NSError(domain: "ImageLoader", code: -2, userInfo: [NSLocalizedDescriptionKey: "Invalid server response"])
                    return
                }
                
                guard let data = data, let image = UIImage(data: data) else {
                    self.error = NSError(domain: "ImageLoader", code: -3, userInfo: [NSLocalizedDescriptionKey: "Invalid image data"])
                    return
                }
                
                self.cache.setObject(image, forKey: url as NSURL)
                
                self.image = image
            }
        }
        task?.resume()
    }
    
    func cancel() {
        task?.cancel()
        task = nil
        isLoading = false
    }
    
    deinit {
        cancel()
    }
}
