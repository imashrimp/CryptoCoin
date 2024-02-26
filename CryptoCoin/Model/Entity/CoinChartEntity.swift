//
//  CoinChartEntity.swift
//  CryptoCoin
//
//  Created by 권현석 on 2/26/24.
//

import Foundation

struct CoinChartEntity {
    let id, symbol, name: String
    let image: URL
    let currentPrice: Int
    let high24H, low24H: Int
    let priceChangePercentage24H: Double
    let ath: Int
    let atl: Int
    let lastUpdated: String
    let oneWeekPriceRecord: [Double]
}

