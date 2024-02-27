//
//  String+Extension.swift
//  CryptoCoin
//
//  Created by 권현석 on 2/27/24.
//

import Foundation

extension String {
    
    func toDate() -> Date? { //M/dd HH:mm:ss
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSX"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            return nil
        }
    }
}

