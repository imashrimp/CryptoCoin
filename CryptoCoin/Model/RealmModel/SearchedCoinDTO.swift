//
//  SeachedCoinDTO.swift
//  CryptoCoin
//
//  Created by 권현석 on 2/26/24.
//

import Foundation
import RealmSwift

final class SearchedCoinDTO: Object {
    @Persisted(primaryKey: true) var coinId: String
    
    convenience init(coinId: String) {
        self.init()
        self.coinId = coinId
    }
}
