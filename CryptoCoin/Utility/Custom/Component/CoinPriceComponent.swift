//
//  CoinPriceComponent.swift
//  CryptoCoin
//
//  Created by 권현석 on 2/26/24.
//

import UIKit

final class CoinPriceComponent: UIStackView {
    
    let priceTypeTitleLabel = {
        let view = UILabel()
        return view
    }()
    
    let priceLabel = {
        let view = UILabel()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    private func configure() {
        [
        priceTypeTitleLabel,
        priceLabel
        ].forEach { self.addArrangedSubview($0) }
    }
    
    
}
