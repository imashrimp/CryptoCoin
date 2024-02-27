//
//  FavoriteCoinsRequestModel.swift
//  CryptoCoin
//
//  Created by 권현석 on 2/27/24.
//

import Foundation

struct FavoriteCoinsRequestModel: Encodable {
    let vs_currency: String
    let ids: String
}
