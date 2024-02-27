//
//  FavoriteCollectionViewCell.swift
//  CryptoCoin
//
//  Created by 권현석 on 2/27/24.
//

import UIKit
import Kingfisher

final class FavoriteCollectionViewCell: BaseCollectionViewCell {
    
    private let cellContentBackgroundView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        return view
    }()
    
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
        
        guard let imageURL = URL(string: data.image) else { return }
        logoImageView.kf.setImage(with: imageURL,
                                  options: [.processor(DownsamplingImageProcessor(size: CGSize(width: 100, height: 100))),
                                            .cacheOriginalImage])
    }
    
    override func configure() {
        contentView.layer.masksToBounds = false
        contentView.layer.shadowOpacity = 0.1
        contentView.layer.shadowOffset = CGSize(width: 0, height: 0)
        contentView.layer.shadowRadius = 3
        
        contentView.addSubview(cellContentBackgroundView)
        
        [
            logoImageView,
            coinNameAndCurrencyStackView,
            priceInfoVerticalStackView
            //        priceLabel,
            //        priceChangePercentLabel
            //        ].forEach { contentView.addSubview($0) }
        ].forEach { cellContentBackgroundView.addSubview($0) }
        
        [
            priceLabel,
            priceChangePercentLabel
        ].forEach { priceInfoVerticalStackView.addArrangedSubview($0) }
    }
    
    override func setConstraints() {
        
        cellContentBackgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        logoImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalTo(coinNameAndCurrencyStackView)
            $0.size.equalTo(32)
        }
        
        coinNameAndCurrencyStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.leading.equalTo(logoImageView.snp.trailing).offset(6)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        priceInfoVerticalStackView.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(coinNameAndCurrencyStackView.snp.bottom).offset(20)
            $0.trailing.bottom.equalToSuperview().inset(16)
            $0.leading.greaterThanOrEqualToSuperview().offset(16)
        }
    }
    
}
