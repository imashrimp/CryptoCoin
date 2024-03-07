//
//  CoinSearchError.swift
//  CryptoCoin
//
//  Created by 권현석 on 2/26/24.
//

import Foundation

enum NetworkError: Int, Error {
    case badRequest = 400
    case Unauthorised = 401
    case forbidden = 403
    case tooManyRequests = 429
    
    var description: String {
        switch self {
        case .badRequest:
            return "잘못된 요청입니다"
        case .Unauthorised:
            return "권한이 없습니다"
        case .forbidden:
            return "권한이 금지되었습니다"
        case .tooManyRequests:
            return "통신 과호출 상태입니다 1분 후 다시 시도해주세요"
        }
    }
}
