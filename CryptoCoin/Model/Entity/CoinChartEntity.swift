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
    let currentPrice: String
    let high24H, low24H: String
    let priceChangePercentage24H: String
    let ath: String
    let atl: String
    let lastUpdated: String
    let oneWeekPriceRecord: [Double]
}
