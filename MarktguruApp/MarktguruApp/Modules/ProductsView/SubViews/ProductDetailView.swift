//
//  ProductDetailView.swift
//  MarktguruApp
//
//  Created by Davit Marukhyan on 15.05.25.
//

import SwiftUI

struct ProductDetailView: View {
    let product: ProductModel
    @StateObject private var viewModel: ProductsViewModel
    @Environment(\.colorScheme) private var colorScheme
    
    init(product: ProductModel, viewModel: ProductsViewModel) {
        self.product = product
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            Color.customBackground.ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    AsyncImageView(url: product.firstImageURL)
                        .frame(height: 300)
                        .frame(maxWidth: .infinity)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding(.horizontal, 10)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("ID: \(product.id)")
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                                
                                Text(product.title)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.primary)
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                viewModel.toggleFavorite(for: product)
                            }) {
                                Image(systemName: viewModel.isFavorite(product) ? "heart.fill" : "heart")
                                    .font(.title)
                                    .foregroundColor(viewModel.isFavorite(product) ? .red : .gray)
                            }
                        }
                        
                        Text("Price: $\(String(format: "%.2f", product.price))")
                            .font(.title3)
                            .foregroundColor(.secondary)
                        
                        Text(product.description)
                            .font(.body)
                            .foregroundColor(.black)
                            .padding(.top, 8)
                    }
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
