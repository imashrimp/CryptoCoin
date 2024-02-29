//
//  PriceInfoVerticalStackView.swift
//  CryptoCoin
//
//  Created by 권현석 on 2/29/24.
//

import UIKit

final class PriceInfoVerticalStackView: UIStackView {
    
    let priceLabel = {
        let view = UILabel()
        return view
    }()
    
    let priceChangePercentLabel = {
        let view = UILabel()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        axis = .vertical
    }
    
    private func configure() {
        [
        priceLabel,
        priceChangePercentLabel
        ].forEach { addArrangedSubview($0) }
    }
    
    @available (*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
