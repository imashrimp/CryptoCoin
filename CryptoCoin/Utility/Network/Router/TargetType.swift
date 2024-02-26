//
//  TargetType.swift
//  CryptoCoin
//
//  Created by 권현석 on 2/26/24.
//

import Foundation
import Alamofire

protocol TargetType: URLRequestConvertible {
    var baseURL: String { get }
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: RequestParams { get }
}

extension TargetType {
    func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL()
        var urlRequest = try URLRequest(url: url.appendingPathComponent(path), method: method)
        //TODO: 헤더 추가해아함
//        urlRequest.allHTTPHeaderFields = [HTTPHeader.clientId.rawValue : APIkey.clientID,
//                                          HTTPHeader.clidentSecret.rawValue : APIkey.clienSecret]

        switch parameters {
        case .query(let request):
            let params = request?.toDictionary() ?? [:]
            let queryParams = params.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
            var components = URLComponents(string: url.appendingPathComponent(path).absoluteString)
            components?.queryItems = queryParams
            urlRequest.url = components?.url
        }

        return urlRequest
    }
}

enum RequestParams {
    case query(_ parameter: Encodable?)
}
