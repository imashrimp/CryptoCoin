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
        }
    }
}
