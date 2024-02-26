//
//  ImageName.swift
//  CryptoCoin
//
//  Created by 권현석 on 2/26/24.
//

import Foundation

enum ImageAsset {
    case chart
    case search
    case wallet
    case person
    case backButton
    case star
    case starFill
    
    var name: String {
        switch self {
        case .chart:
            return "chart.xyaxis.line"
        case .search:
            return "magnifyingglass"
        case .wallet:
            return "folder"
        case .person:
            return "person"
        case .backButton:
            return "chevron.backward"
        case .star:
            return "star"
        case .starFill:
            return "star.fill"
        }
    }
}
