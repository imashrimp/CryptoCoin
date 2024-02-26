//
//  API.swift
//  CryptoCoin
//
//  Created by 권현석 on 2/26/24.
//

import Foundation
import Alamofire

final class API {
    static let session: Session = {
        let configuration = URLSessionConfiguration.af.default
        let apiLogger = APIEventLogger()
        return Session(configuration: configuration, eventMonitors: [apiLogger])
    }()
}
