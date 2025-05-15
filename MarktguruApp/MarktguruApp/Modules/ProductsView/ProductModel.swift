//
//  ProductModel.swift
//  MarktguruApp
//
//  Created by Davit Marukhyan on 15.05.25.
//

import Foundation

struct ProductModel: Identifiable, Codable, Equatable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let images: [String]
    
    var firstImageURL: URL? {
        guard let firstImage = images.first else { return nil }
        return URL(string: firstImage)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case price
        case description
        case images
    }
}
