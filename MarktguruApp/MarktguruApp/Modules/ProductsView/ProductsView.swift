//
//  ProductsView.swift
//  MarktguruApp
//
//  Created by Davit Marukhyan on 15.05.25.
//

import SwiftUI

struct ProductsView: View {
    @StateObject private var viewModel = ProductsViewModel()
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.customBackground.ignoresSafeArea()
                
                if viewModel.error != nil {
                    VStack {
                        Text("Error loading products")
                            .foregroundColor(.secondary)
                        Button("Try Again") {
                            Task {
                                await viewModel.loadInitialProducts()
                            }
                        }
                    }
                } else {
                    List {
                        ForEach(viewModel.products) { product in
                            ZStack {
                                NavigationLink(destination: ProductDetailView(product: product, viewModel: viewModel)) {
                                    EmptyView()
                                }
                                .opacity(0)
                                
                                ProductRowView(
                                    product: product,
                                    isFavorite: viewModel.isFavorite(product),
                                    onFavoriteToggle: {
                                        viewModel.toggleFavorite(for: product)
                                    },
                                    onAppear: {
                                        if viewModel.shouldLoadMore(for: product) {
                                            Task {
                                                await viewModel.loadMoreProducts()
                                            }
                                        }
                                    }
                                )
                            }
                            .listRowBackground(Color.customBackground)
                        }
                        
                        if viewModel.isLoading {
                            ProgressView()
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding()
                                .listRowBackground(Color.customBackground)
                        }
                    }
                    .listStyle(PlainListStyle())
                    .scrollContentBackground(.hidden)
                    .refreshable {
                        await viewModel.loadInitialProducts()
                    }
                }
            }
            .navigationTitle("Products")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: FavoritesView(viewModel: viewModel)) {
                        Image(systemName: "heart.fill")
                            .foregroundColor(.red)
                    }
                }
            }
            .task {
                await viewModel.loadInitialProducts()
            }
        }
    }
}
