//
//  CoinChartViewController.swift
//  CryptoCoin
//
//  Created by 권현석 on 2/26/24.
//

import UIKit
import Kingfisher

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
        bind()
        
    }
    
    private func bind() {
//        let input = CoinCharViewModel.Input(likeButtonTapped: )
        
//        viewModel.transform(input: input)
        
        let output = viewModel.output
        
        output
            .coinChartData
            .bind(with: self) { owner, value in
//                owner.baseView.logoImageView.kf.setImage(with: value.image)
//                owner.baseView.currentPriceLabel.text = value.currentPrice
//                owner.baseView.priceChangePercentLabel.text = value.priceChangePercentage24H
            }
            .disposed(by: disposeBag)
    }
}
