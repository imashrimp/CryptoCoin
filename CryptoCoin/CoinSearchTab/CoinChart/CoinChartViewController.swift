//
//  CoinChartViewController.swift
//  CryptoCoin
//
//  Created by 권현석 on 2/26/24.
//

import UIKit

final class CoinChartViewController: BaseViewController {

    private let viewModel: CoinCharViewModel
    private let baseView = CoinChartView()
    
    init(viewModel: CoinCharViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func loadView() {
        self.view = baseView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    
    override func configure() {
        super.configure()
    }
}
