//
//  CoinSearchResponseModel.swift
//  CryptoCoin
//
//  Created by 권현석 on 2/26/24.
//

import Foundation

struct CoinSearchResponseModel: Decodable {
    let coins: [Coin]
}

// MARK: - Coin
struct Coin: Decodable {
    let id, name, symbol: String
    let large: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case symbol
        case large
    }
}

extension CoinSearchResponseModel {
    func toDomain() -> [SearchedCoinEntity] {
        return self.coins.map {
            SearchedCoinEntity(
                id: $0.id,
                name: $0.name,
                currencyUnit: $0.symbol,
                logo: $0.large
            )
        }
    }
}
