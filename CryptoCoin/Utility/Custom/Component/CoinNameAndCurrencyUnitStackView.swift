//
//  coinNameAndCurrencyUnitStackView.swift
//  CryptoCoin
//
//  Created by 권현석 on 2/27/24.
//

import UIKit

final class CoinNameAndCurrencyUnitStackView: UIStackView {
    
    let coinNameLabel = {
        let view = UILabel()
        return view
    }()
    
    let currencyUnitLabel = {
        let view = UILabel()
        view.textColor = UIColor(hexCode: ColorHexCode.gray.colorCode)
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        axis = .vertical
    }
    
    private func configure() {
        [
        coinNameLabel,
        currencyUnitLabel
        ].forEach { addArrangedSubview($0) }
    }

    @available (*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
