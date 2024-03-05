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
}

struct SparklineIn7D: Decodable {
    let price: [Double]
}

typealias CoinChartDataDTO = [CoinChartResponseModel]

extension CoinChartDataDTO {
    func toDomain() -> CoinChartEntity {
        if let coinData = self.first,
           let imageURL = URL(string: coinData.image),
           let updateDate = coinData.lastUpdated.toDate() {
            return CoinChartEntity(
                id: coinData.id,
                symbol: coinData.symbol,
                name: coinData.name,
                image: imageURL,
                currentPrice: coinData.currentPrice.convertToDecimal(),
                high24H: coinData.high24H.convertToDecimal(),
                low24H: coinData.low24H.convertToDecimal(),
                priceChangePercentage24H: coinData.priceChangePercentage24H.convertToPercentage(),
                ath: coinData.ath.convertToDecimal(),
                atl: coinData.atl.convertToDecimal(),
                lastUpdated: updateDate.toString(format: "M/dd HH:mm:ss") + " 업데이트",
                oneWeekPriceRecord: coinData.sparklineIn7D.price
            )
        } else {
            return CoinChartEntity(
                id: "",
                symbol: "",
                name: "",
                image: URL(string: "")!,
                currentPrice: "",
                high24H: "",
                low24H: "",
                priceChangePercentage24H: "",
                ath: "",
                atl: "",
                lastUpdated: "",
                oneWeekPriceRecord: [0.0]
            )
        }
    }
}

