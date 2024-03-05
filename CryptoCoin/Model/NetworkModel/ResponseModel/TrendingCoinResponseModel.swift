//
//  TrendingCoinResponseModel.swift
//  CryptoCoin
//
//  Created by 권현석 on 2/27/24.
//

import Foundation

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

extension TrendingCoinResponseModel {
    func toDomain() -> [TrendEntity] {
        let trendCoinArr = self.coins.map {
            PresentItemEntity(
                id: $0.item.id,
                name: $0.item.name,
                currency: $0.item.symbol,
                thumbnail: $0.item.thumb,
                price: $0.item.data.price,
                priceChangePercent24H: $0.item.data.priceChangePercentage24H["krw"]?.convertToPercentage() ?? "0.0%"
            )
        }
        
        let trendCoinPresentData = TrendEntity(
            sectionTitle: "Top 15 Coin",
            data: trendCoinArr
        )
        
        let trendNFTArr = self.nfts.map {
            PresentItemEntity(
                id: "",
                name: $0.name,
                currency: $0.symbol,
                thumbnail: $0.thumb,
                price: $0.data.floorPrice,
                priceChangePercent24H: $0.data.floorPriceInUsd24HPercentageChange.convertToPercent()
            )
        }
        
        let trendNFTPresentData = TrendEntity(
            sectionTitle: "Top 7 NFT",
            data: trendNFTArr
        )
    
        return [trendCoinPresentData, trendNFTPresentData]
    }
}
