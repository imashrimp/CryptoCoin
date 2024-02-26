//
//  CoinSearchResponseModel.swift
//  CryptoCoin
//
//  Created by 권현석 on 2/26/24.
//

import Foundation

struct CoinSearchResponseModel: Codable {
    let coins: [Coin]
}

// MARK: - Coin
struct Coin: Codable {
    let id, name, symbol: String
    let large: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case symbol
        case large
    }
}
