//
//  APIEventLogger.swift
//  CryptoCoin
//
//  Created by 권현석 on 2/26/24.
//

import Foundation
import Alamofire

class APIEventLogger: EventMonitor {

    let queue = DispatchQueue(label: "myNetworkLogger")

    func requestDidFinish(_ request: Request) {
      print("🛰 NETWORK Reqeust LOG")
      print(request.description)

      print(
        "URL: " + (request.request?.url?.absoluteString ?? "")  + "\n"
          + "Method: " + (request.request?.httpMethod ?? "") + "\n"
          + "Headers: " + "\(request.request?.allHTTPHeaderFields ?? [:])" + "\n"
      )
      print("Authorization: " + (request.request?.headers["Authorization"] ?? ""))
      print("Body: " + (request.request?.httpBody?.toPrettyPrintedString ?? ""))
    }

    func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        print("🛰 NETWORK Response LOG")
        print(
          "URL: " + (request.request?.url?.absoluteString ?? "") + "\n"
            + "Result: " + "\(response.result)" + "\n"
            + "StatusCode: " + "\(response.response?.statusCode ?? 0)" + "\n"
            + "Data: \(response.data?.toPrettyPrintedString ?? "")"
        )
    }
}
