//
//  ColorHexCodeEnum.swift
//  CryptoCoin
//
//  Created by 권현석 on 2/26/24.
//

import UIKit

enum ColorHexCode {
    case purple
    case red
    case pink
    case blue
    case lightBlue
    case black
    case gray
    case darkGray
    case lightGray
    case white
    
    var colorCode: String {
        switch self {
        case .purple:
            return "914CF5"
        case .red:
            return "F04452"
        case .pink:
            return "#FCE8F9"
        case .blue:
            return "3282F8"
        case .lightBlue:
            return "E5F0FF"
        case .black:
            return "000000"
        case .gray:
            return "828282"
        case .darkGray:
            return "343D4C"
        case .lightGray:
            return "F3F4F6"
        case .white:
            return "FFFFFF"
        }
    }
}


