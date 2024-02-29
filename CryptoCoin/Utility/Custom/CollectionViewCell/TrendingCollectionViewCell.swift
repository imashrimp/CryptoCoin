//
//  TrendingCollectionViewCell.swift
//  CryptoCoin
//
//  Created by 권현석 on 2/28/24.
//

import UIKit
import Kingfisher
import RxSwift
import RxCocoa

final class TrendingCollectionViewCell: BaseCollectionViewCell {
    
    var disposeBag = DisposeBag()
    
//    private let trendingTableView = {
//        let view = UITableView()
//        return view
//    }()
    
    private let rankLabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 24,
                                weight: .bold)
        return view
    }()
    
    private let logoImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let coinInfoComponent = {
        let view = CoinNameAndCurrencyUnitStackView()
        view.coinNameLabel.font = .systemFont(ofSize: 15,
                                              weight: .bold)
        view.currencyUnitLabel.font = .systemFont(ofSize: 13)
        return view
    }()
    
    private let coinPriceComponent = {
        let view = PriceInfoVerticalStackView()
        view.priceLabel.font = .systemFont(ofSize: 15)
        view.priceChangePercentLabel.font = .systemFont(ofSize: 13)
        view.alignment = .trailing
        return view
    }()
    
    func showContents(index: Int, data: PresentItemEntity) {
        rankLabel.text = "\(index + 1)"
        coinInfoComponent.coinNameLabel.text = data.name
        coinInfoComponent.currencyUnitLabel.text = data.currency
        coinPriceComponent.priceLabel.text = data.price
        coinPriceComponent.priceChangePercentLabel.text = data.priceChangePercent24H
        
        guard let url = URL(string: data.thumbnail) else { return }
        logoImageView.kf.setImage(with: url)
    }
    
    
    override func configure() {
        
//        [
//        trendingTableView
//        ].forEach { contentView.addSubview($0) }
        [
        rankLabel,
        logoImageView,
        coinInfoComponent,
        coinPriceComponent
        ].forEach { contentView.addSubview($0) }
    }
    
    override func setConstraints() {
        
//        trendingTableView.snp.makeConstraints {
//            $0.verticalEdges.equalToSuperview().inset(8)
//            $0.horizontalEdges.equalToSuperview().inset(12)
//        }
        rankLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(12)
            $0.centerY.equalTo(coinInfoComponent)
        }
        
        logoImageView.snp.makeConstraints {
            $0.leading.equalTo(rankLabel.snp.trailing).offset(16)
            $0.size.equalTo(36)
            $0.centerY.equalTo(coinInfoComponent)
        }
        
        coinInfoComponent.snp.makeConstraints {
            $0.leading.equalTo(logoImageView.snp.trailing).offset(16)
            $0.verticalEdges.equalToSuperview().inset(8)
            $0.trailing.lessThanOrEqualTo(coinPriceComponent.snp.leading).inset(4)
        }
        
        coinPriceComponent.snp.makeConstraints {
//            $0.verticalEdges.equalToSuperview().inset(12)
            $0.centerY.equalTo(coinInfoComponent)
            $0.trailing.equalToSuperview().inset(16)
        }
    }
}
