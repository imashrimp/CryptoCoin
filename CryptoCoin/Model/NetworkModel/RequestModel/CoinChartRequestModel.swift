//
//  CoinChartRequestModel.swift
//  CryptoCoin
//
//  Created by 권현석 on 2/26/24.
//

import Foundation

struct CoinChartRequestModel: Encodable {
    let vs_currency: String
    let ids: String
    let sparkline: String
}
