//
//  SearchedCoinTableViewCell.swift
//  CryptoCoin
//
//  Created by 권현석 on 2/26/24.
//

import UIKit
import Kingfisher

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
        view.font = .systemFont(ofSize: 17, 
                                weight: .heavy)
        return view
    }()
    
    private let currencyUnitLabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 13,
                                weight: .bold)
        view.textColor = UIColor(hexCode: ColorHexCode.gray.colorCode)
        return view
    }()
    
    private let likeButtonImage = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.tintColor = UIColor(hexCode: ColorHexCode.purple.colorCode)
        view.image = UIImage(systemName: ImageAsset.star.name)
        return view
    }()
    
    let likeButton = UIButton()
    
    func showContents(data: SearchedCoinEntity) {
        coinNameLabel.text = data.name
        currencyUnitLabel.text = data.currencyUnit
        
        guard let url = URL(string: data.logo) else { return }
        logoImageView.kf.setImage(with: url,
                                  options: [.processor(DownsamplingImageProcessor(size: CGSize(width: 100, height: 100)))])
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        coinNameLabel.text = nil
        currencyUnitLabel.text = nil
        logoImageView.image = nil
        likeButtonImage.image = nil
    }
    
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
            $0.size.equalTo(36)
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalTo(coinNameAndCurrencyUnitStackView)
        }
        
        coinNameAndCurrencyUnitStackView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(12)
            $0.leading.equalTo(logoImageView.snp.trailing).offset(16)
            $0.trailing.lessThanOrEqualTo(likeButton.snp.leading).inset(16)
        }
        
        likeButtonImage.snp.makeConstraints {
            $0.centerY.equalTo(coinNameAndCurrencyUnitStackView)
            $0.trailing.equalToSuperview().inset(16)
            $0.size.equalTo(24)
        }
        
        likeButton.snp.makeConstraints {
            $0.edges.equalTo(likeButtonImage).inset(-4)
        }
    }
}
