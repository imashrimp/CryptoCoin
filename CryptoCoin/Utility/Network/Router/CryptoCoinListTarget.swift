//
//  CryptoCoinListTarget.swift
//  CryptoCoin
//
//  Created by 권현석 on 2/26/24.
//

import Foundation
import Alamofire

enum CryptoCoinListTarget {
    case search(CoinSearchRequestModel)
    case coinChart(CoinChartRequestModel)
}

extension CryptoCoinListTarget: TargetType {
    
    var baseURL: String {
        return "https://api.coingecko.com/api/v3"
    }
    
    var method: HTTPMethod {
        switch self {
        case .search(_):
            return .get
        case .coinChart(_):
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .search(_):
            return "/search"
        case .coinChart(_):
            return "/coins/markets"
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .search(let searchWord):
            return .query(searchWord)
        case .coinChart(let query):
            return .query(query)
        }
    }
}
