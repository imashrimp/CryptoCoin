//
//  CoinChartResponseModel.swift
//  CryptoCoin
//
//  Created by 권현석 on 2/26/24.
//

import Foundation

struct CoinChartResponseModel: Decodable {
    let id, symbol, name: String
    let image: String
    let currentPrice: Double
    let high24H, low24H: Double
    let priceChangePercentage24H: Double
    let ath: Double
    let atl: Double
    let lastUpdated: String
    let sparklineIn7D: SparklineIn7D
    
    enum CodingKeys: String, CodingKey {
        case id, symbol, name, image
        case currentPrice = "current_price"
        case high24H = "high_24h"
        case low24H = "low_24h"
        case priceChangePercentage24H = "price_change_percentage_24h"
        case ath
        case atl
        case lastUpdated = "last_updated"
        case sparklineIn7D = "sparkline_in_7d"
    }
    
//    func toDomain() -> CoinChartEntity {
//        
//    }
}

struct SparklineIn7D: Decodable {
    let price: [Double]
}

