//
//  FavoriteCoinInfoResponseModel.swift
//  CryptoCoin
//
//  Created by 권현석 on 2/27/24.
//

import Foundation

struct FavoriteCoinInfoResponseModel: Decodable {
    let id, symbol, name: String
    let image: String
    let currentPrice: Double
    let priceChangePercentage24H: Double
    
    enum CodingKeys: String, CodingKey {
        case id, symbol, name, image
        case currentPrice = "current_price"
        case priceChangePercentage24H = "price_change_percentage_24h"
    }
}
