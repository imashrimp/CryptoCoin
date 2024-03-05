//
//  BackgroundView.swift
//  CryptoCoin
//
//  Created by 권현석 on 3/5/24.
//

import UIKit

final class BackgroundView: BaseView {
    
    private var retryButtonCompletion: (() -> Void)?
    
    private let veticalStackView = {
        let view = UIStackView()
        view.alignment = .center
        view.axis = .vertical
        view.spacing = 16
        return view
    }()
    
    private let stateMessageLabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 20, weight: .heavy)
        view.textColor = UIColor(hexCode: ColorHexCode.gray.colorCode, alpha: 0.8)
        return view
    }()
    
    private let networkRetryButton = {
        let view = UIButton()
        view.setTitle("재시도", for: .normal)
        view.setTitleColor(UIColor(hexCode: ColorHexCode.white.colorCode), for: .normal)
        view.backgroundColor = UIColor(hexCode: ColorHexCode.purple.colorCode)
        view.layer.cornerRadius = 8
        return view
    }()
    
    init(message: String, buttonHidden: Bool = true, retrtyButtonTapped: (() -> Void)? = nil) {
        
        self.stateMessageLabel.text = message
        self.networkRetryButton.isHidden = buttonHidden
        self.retryButtonCompletion = retrtyButtonTapped
        super.init(frame: .zero)
        networkRetryButton.addTarget(self,
                                     action: #selector(networkRetryButtonTapped),
                                     for: .touchUpInside)
    }
    
    @objc private func networkRetryButtonTapped() {
        retryButtonCompletion?()
    }
    
    override func configure() {
        super.configure()
        
        [
        veticalStackView
        ].forEach { addSubview($0) }
        
        [
            stateMessageLabel,
            networkRetryButton
        ].forEach { veticalStackView.addArrangedSubview($0) }
    }
    
    override func setConstrinats() {
        
        networkRetryButton.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.width.equalTo(120)
        }
        
        veticalStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        

    }
}
