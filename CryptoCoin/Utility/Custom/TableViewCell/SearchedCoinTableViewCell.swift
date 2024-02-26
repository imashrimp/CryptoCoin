//
//  SearchedCoinTableViewCell.swift
//  CryptoCoin
//
//  Created by 권현석 on 2/26/24.
//

import UIKit

final class SearchedCoinTableViewCell: BaseTableViewCell {
    private let logoImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let coinNameAndCurrencyUnitStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 4
        return view
    }()
    
    private let coinNameLabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 15)
        return view
    }()
    
    private let currencyUnitLabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 13)
        view.textColor = UIColor(hexCode: ColorHexCode.gray.colorCode)
        return view
    }()
    
    private let likeButtonImage = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.tintColor = UIColor(hexCode: ColorHexCode.purple.colorCode)
        return view
    }()
    
    private let likeButton = UIButton()
    
    override func configure() {
        [
        logoImageView,
        coinNameAndCurrencyUnitStackView,
        likeButtonImage,
        likeButton
        ].forEach { contentView.addSubview($0) }
        
        [
            coinNameLabel,
            currencyUnitLabel
        ].forEach { coinNameAndCurrencyUnitStackView.addArrangedSubview($0) }
    }
    
    override func setConstraints() {
        logoImageView.snp.makeConstraints {
            $0.size.equalTo(52)
            $0.leading.equalToSuperview().offset(12)
            $0.centerY.equalTo(coinNameAndCurrencyUnitStackView)
        }
        
        coinNameAndCurrencyUnitStackView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(4)
            $0.leading.equalTo(logoImageView.snp.trailing).offset(12)
            $0.trailing.lessThanOrEqualTo(likeButton.snp.leading).inset(16)
        }
        
        likeButtonImage.snp.makeConstraints {
            $0.centerY.equalTo(coinNameAndCurrencyUnitStackView)
            $0.trailing.equalToSuperview().inset(12)
            $0.size.equalTo(40)
        }
        
        likeButton.snp.makeConstraints {
            $0.edges.equalTo(likeButtonImage).inset(-4)
        }
    }
}
