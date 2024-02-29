//
//  CryptoCoinListTarget.swift
//  CryptoCoin
//
//  Created by 권현석 on 2/26/24.
//

import Foundation
import Alamofire

enum CryptoCoinListTarget {
    case trending
    case search(CoinSearchRequestModel)
    case coinChart(CoinChartRequestModel)
    case favoriteCoins(FavoriteCoinsRequestModel)
}

extension CryptoCoinListTarget: TargetType {
    
    var baseURL: String {
        return "https://api.coingecko.com/api/v3"
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var path: String {
        switch self {
        case .search(_):
            return "/search"
        case .coinChart(_):
            return "/coins/markets"
        case .favoriteCoins(_):
            return "/coins/markets"
        case .trending:
            return "search/trending"
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .search(let searchWord):
            return .query(searchWord)
        case .coinChart(let query):
            return .query(query)
        case .favoriteCoins(let query):
            return .query(query)
        case .trending:
            return .query(nil)
        }
    }
}
