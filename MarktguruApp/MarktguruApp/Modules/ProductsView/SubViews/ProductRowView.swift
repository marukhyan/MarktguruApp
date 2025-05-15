//
//  ProductRowView.swift
//  MarktguruApp
//
//  Created by Davit Marukhyan on 15.05.25.
//

import SwiftUI

struct ProductRowView: View {
    let product: ProductModel
    let isFavorite: Bool
    let onFavoriteToggle: () -> Void
    let onAppear: () -> Void
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        HStack(spacing: 12) {
            AsyncImageView(url: product.firstImageURL)
                .frame(width: 80, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(product.title)
                    .font(.headline)
                    .lineLimit(2)
                    .foregroundColor(.primary)
                
                Text("$\(String(format: "%.2f", product.price))")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button(action: {
                onFavoriteToggle()
            }) {
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                    .foregroundColor(isFavorite ? .red : .gray)
                    .font(.title2)
            }
            .buttonStyle(BorderlessButtonStyle())
            .contentShape(Rectangle())
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .onAppear(perform: onAppear)
    }
}
