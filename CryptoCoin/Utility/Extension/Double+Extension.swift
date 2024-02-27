//
//  Double+Extension.swift
//  CryptoCoin
//
//  Created by 권현석 on 2/27/24.
//

import Foundation

extension Double {
    func convertToPercentage() -> String {
        let percentValue = String(format: "%.2f", self)
        return  percentValue + "%"
    }
    
    func convertToDecimal() -> String {
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let result = numberFormatter.string(for: self)
        
        guard let result else { return "0.00" }
        return "₩" + result
    }
}
