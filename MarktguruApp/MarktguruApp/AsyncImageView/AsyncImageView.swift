//
//  AsyncImageView.swift
//  MarktguruApp
//
//  Created by Davit Marukhyan on 15.05.25.
//

import SwiftUI

struct AsyncImageView: View {
    @StateObject private var imageLoader = ImageLoader()
    let url: URL?
    
    var body: some View {
        Group {
            if let image = imageLoader.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else if imageLoader.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.gray.opacity(0.1))
            } else if imageLoader.error != nil {
                Image(systemName: "exclamationmark.triangle")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.gray.opacity(0.1))
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.gray.opacity(0.1))
            }
        }
        .onAppear {
            imageLoader.load(url: url)
        }
        .onDisappear {
            imageLoader.cancel()
        }
    }
}
