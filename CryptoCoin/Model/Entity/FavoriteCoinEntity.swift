//
//  FavoriteCoinEntity.swift
//  CryptoCoin
//
//  Created by 권현석 on 2/27/24.
//

import Foundation

struct FavoriteCoinEntity: Decodable {
    let id, name, currency: String
    let image: String
    let currentPrice: String
    let priceChangePercentage24H: String
}
