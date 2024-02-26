//
//  CoinChartView.swift
//  CryptoCoin
//
//  Created by 권현석 on 2/26/24.
//

import UIKit
import DGCharts

final class CoinChartView: BaseView {
    
    let logoImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let coinTitleLabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 38,
                                weight: .bold)
        
        return view
    }()
    
    let currentPriceLabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 38,
                                weight: .bold)
        return view
    }()
    
    let priceChangePercentLabel = {
        let view = UILabel()
        return view
    }()
    
    let dayLabel = {
        let view = UILabel()
        return view
    }()
    
    let highPriceStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 16
        return view
    }()
    
    let lowPriceStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 16
        return view
    }()
    
    //고가
    let highPriceComponent = CoinPriceComponent()
    //저가
    let lowPriceComponent = CoinPriceComponent()
    //신고점
    let highestPriceComponent = CoinPriceComponent()
    //신저점
    let lowestPriceComponent = CoinPriceComponent()
    
    override func configure() {
        super.configure()
        [
            logoImageView,
            coinTitleLabel,
            currentPriceLabel,
            priceChangePercentLabel,
            dayLabel,
            highPriceStackView,
            lowPriceStackView
        ].forEach { addSubview($0) }
        
        [
            highPriceComponent,
            highestPriceComponent,
        ].forEach { highPriceStackView.addArrangedSubview($0) }
        
        [
            lowPriceComponent,
            lowestPriceComponent
        ].forEach { lowPriceStackView.addArrangedSubview($0) }
        
    }
    
    override func setConstrinats() {
        logoImageView.snp.makeConstraints {
            $0.size.equalTo(40)
            $0.top.leading.equalToSuperview().offset(16)
        }
        
        currentPriceLabel.snp.makeConstraints {
            $0.centerY.equalTo(logoImageView)
            $0.leading.equalTo(logoImageView.snp.trailing).offset(12)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        currentPriceLabel.snp.makeConstraints {
            $0.top.equalTo(logoImageView.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        priceChangePercentLabel.snp.makeConstraints {
            $0.top.equalTo(currentPriceLabel.snp.bottom).offset(12)
            $0.leading.equalToSuperview().offset(16)
        }
        
        dayLabel.snp.makeConstraints {
            $0.top.equalTo(priceChangePercentLabel)
            $0.leading.equalTo(priceChangePercentLabel).offset(12)
            $0.trailing.lessThanOrEqualToSuperview().inset(16)
        }
        
        highPriceStackView.snp.makeConstraints {
            $0.top.equalTo(dayLabel.snp.bottom).offset(40)
            $0.leading.equalToSuperview().offset(16)
        }
        
        lowPriceStackView.snp.makeConstraints {
            $0.top.equalTo(highPriceStackView)
            $0.leading.equalTo(highPriceComponent.snp.trailing).offset(40)
            $0.trailing.lessThanOrEqualToSuperview().inset(16)
        }
    }
}
