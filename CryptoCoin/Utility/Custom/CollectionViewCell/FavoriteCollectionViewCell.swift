//
//  FavoriteCollectionViewCell.swift
//  CryptoCoin
//
//  Created by 권현석 on 2/27/24.
//

import UIKit
import Kingfisher

final class FavoriteCollectionViewCell: BaseCollectionViewCell {
    
    private let logoImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let coinNameAndCurrencyStackView = CoinNameAndCurrencyUnitStackView()
    
    private let priceInfoVerticalStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .trailing
        view.spacing = 4
        return view
    }()
    
    private let priceLabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 17,
                                weight: .heavy)
        return view
    }()
    
    private let priceChangePercentLabel = {
        let view = PaddingLabel(padding: UIEdgeInsets(top: 2, left: 6, bottom: 2, right: 6))
        view.clipsToBounds = true
        view.layer.cornerRadius = 4
        return view
    }()
    
    func showContents(data: FavoriteCoinEntity) {
        coinNameAndCurrencyStackView.coinNameLabel.text = data.name
        coinNameAndCurrencyStackView.currencyUnitLabel.text = data.currency
        
        priceLabel.text = data.currentPrice
        priceChangePercentLabel.text = data.priceChangePercentage24H
    }
    
    override func configure() {
        contentView.backgroundColor = UIColor(hexCode: ColorHexCode.white.colorCode)
        [
            logoImageView,
            coinNameAndCurrencyStackView,
            priceInfoVerticalStackView
            //        priceLabel,
            //        priceChangePercentLabel
        ].forEach { contentView.addSubview($0) }
        
        [
            priceLabel,
            priceChangePercentLabel
        ].forEach { priceInfoVerticalStackView.addArrangedSubview($0) }
    }
    
    override func setConstraints() {
        logoImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalTo(coinNameAndCurrencyStackView)
            $0.size.equalTo(32)
        }
        
        coinNameAndCurrencyStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.leading.equalTo(logoImageView.snp.trailing).offset(6)
        }
        
        priceInfoVerticalStackView.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(coinNameAndCurrencyStackView.snp.bottom).offset(20)
            $0.trailing.bottom.equalToSuperview().inset(16)
            $0.leading.greaterThanOrEqualToSuperview().offset(16)
        }
    }
    
}
