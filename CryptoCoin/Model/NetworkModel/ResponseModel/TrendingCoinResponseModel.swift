//
//  TrendingCoinResponseModel.swift
//  CryptoCoin
//
//  Created by 권현석 on 2/27/24.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let music = try? JSONDecoder().decode(Music.self, from: jsonData)

import Foundation

// MARK: - Music
struct TrendingCoinResponseModel: Decodable {
    let coins: [TrendingCoin]
    let nfts: [Nft]
}

// MARK: - Coin
struct TrendingCoin: Decodable {
    let item: Item
}

// MARK: - Item
struct Item: Decodable {
    let id: String
    let name, symbol: String
    let marketCapRank: Int
    let thumb: String
    let data: ItemData

    enum CodingKeys: String, CodingKey {
        case id, name, symbol
        case marketCapRank = "market_cap_rank"
        case thumb
        case data
    }
}

// MARK: - ItemData
struct ItemData: Decodable {
    let price: String
    let priceChangePercentage24H: [String: Double]

    enum CodingKeys: String, CodingKey {
        case price
        case priceChangePercentage24H = "price_change_percentage_24h"
    }
}

// MARK: - Nft
struct Nft: Decodable {
    let id: String
    let name, symbol: String
    let thumb: String
    let data: NftData

    enum CodingKeys: String, CodingKey {
        case id, name, symbol, thumb
        case data
    }
}

// MARK: - NftData
struct NftData: Decodable {
    let floorPrice, floorPriceInUsd24HPercentageChange: String

    enum CodingKeys: String, CodingKey {
        case floorPrice = "floor_price"
        case floorPriceInUsd24HPercentageChange = "floor_price_in_usd_24h_percentage_change"
    }
}
