//
//  FavoriteCoinChartViewController.swift
//  CryptoCoin
//
//  Created by 권현석 on 2/27/24.
//

import UIKit

final class FavoriteCoinChartViewController: BaseViewController {
    
    private let baseView = CoinChartView()
    private let viewModel: FavoriteCoinChartViewModel
    
    init(viewModel: FavoriteCoinChartViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    
    override func loadView() {
        self.view = baseView
    }
    
    
}
