//
//  TrandingFavoriteCollectionViewCell.swift
//  CryptoCoin
//
//  Created by 권현석 on 2/28/24.
//

import UIKit
import Kingfisher

final class TrendingFavoriteCollectionViewCell: BaseCollectionViewCell {
    
    private let logoImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let coinNameAndCurrencyStackView = {
        let view = CoinNameAndCurrencyUnitStackView()
        view.coinNameLabel.font = .systemFont(ofSize: 17,
                                              weight: .heavy)
        view.currencyUnitLabel.font = .systemFont(ofSize: 15,
                                                  weight: .bold)
        return view
    }()
    
    private let priceInfoVerticalStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .leading
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
        view.font = .systemFont(ofSize: 17, weight: .bold)
        return view
    }()
    
    func showContents(data: PresentItemEntity) {
        coinNameAndCurrencyStackView.coinNameLabel.text = data.name
        coinNameAndCurrencyStackView.currencyUnitLabel.text = data.currency
        
        priceLabel.text = data.price
        
        let plusOrMinus = data.priceChangePercent24H.prefix(1)
        
        if plusOrMinus == "-" {
            priceChangePercentLabel.textColor = UIColor(hexCode: ColorHexCode.blue.colorCode)
            priceChangePercentLabel.text = data.priceChangePercent24H
        } else {
            priceChangePercentLabel.textColor = UIColor(hexCode: ColorHexCode.red.colorCode)
            priceChangePercentLabel.text = "+" + data.priceChangePercent24H
        }
        
        guard let imageURL = URL(string: data.thumbnail) else { return }
        logoImageView.kf.setImage(with: imageURL,
                                  options: [.cacheOriginalImage])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    override func configure() {
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 10
        contentView.backgroundColor = UIColor(hexCode: ColorHexCode.lightGray.colorCode)

        [
            logoImageView,
            coinNameAndCurrencyStackView,
            priceInfoVerticalStackView
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
            $0.size.equalTo(40)
        }
        
        coinNameAndCurrencyStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalTo(logoImageView.snp.trailing).offset(6)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        priceInfoVerticalStackView.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(coinNameAndCurrencyStackView.snp.bottom).offset(8)
            $0.leading.bottom.equalToSuperview().inset(16)
            $0.trailing.lessThanOrEqualToSuperview().offset(16)
        }
    }
    
}

