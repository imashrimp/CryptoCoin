//
//  Int+Extension.swift
//  CryptoCoin
//
//  Created by 권현석 on 2/27/24.
//

import Foundation

extension Int {
    
    func decimal() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let result = numberFormatter.string(for: self)
        
        guard let result else { return "0" }
        return "₩" + result
    }
}
