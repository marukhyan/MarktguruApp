//
//  FavoritesView.swift
//  MarktguruApp
//
//  Created by Davit Marukhyan on 15.05.25.
//

import SwiftUI

struct FavoritesView: View {
    @ObservedObject var viewModel: ProductsViewModel
    @Environment(\.colorScheme) private var colorScheme
    
    var favoriteProducts: [ProductModel] {
        viewModel.products.filter { viewModel.isFavorite($0) }
    }
    
    var body: some View {
        ZStack {
            Color.customBackground.ignoresSafeArea()
            
            List {
                if favoriteProducts.isEmpty {
                    Text("No favorites yet")
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                        .listRowBackground(Color.customBackground)
                } else {
                    ForEach(favoriteProducts) { product in
                        NavigationLink(destination: ProductDetailView(product: product, viewModel: viewModel)) {
                            ProductRowView(
                                product: product,
                                isFavorite: true,
                                onFavoriteToggle: {
                                    viewModel.toggleFavorite(for: product)
                                },
                                onAppear: { }
                            )
                        }
                        .listRowBackground(Color.customBackground)
                    }
                }
            }
            .listStyle(PlainListStyle())
            .scrollContentBackground(.hidden)
        }
        .navigationTitle("Favorites")
        .navigationBarTitleDisplayMode(.large)
    }
}
