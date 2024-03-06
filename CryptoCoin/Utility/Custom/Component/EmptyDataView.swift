//
//  BackgroundView.swift
//  CryptoCoin
//
//  Created by 권현석 on 3/5/24.
//

import UIKit

final class EmptyDataView: BaseView {
    
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
    
    let networkRetryButton = {
        let view = UIButton()
        view.setTitle("재시도", for: .normal)
        view.setTitleColor(UIColor(hexCode: ColorHexCode.white.colorCode), for: .normal)
        view.backgroundColor = UIColor(hexCode: ColorHexCode.purple.colorCode)
        view.layer.cornerRadius = 8
        return view
    }()
    
    init(viewState: BackgroundViewState, retryButtonCompletion: (() -> Void)? = nil) {
        super.init(frame: .zero)
        switch viewState {
        case .connectedWithoutData:
            stateMessageLabel.text = "데이터가 없습니다"
            networkRetryButton.isHidden = true
        case .networkDisconnect:
            stateMessageLabel.text = "네트워크 연결 상태를 확인해주세요"
            networkRetryButton.isHidden = false
            networkRetryButton.addTarget(self,
                                         action: #selector(networkRetryButtonTapped),
                                         for: .touchUpInside)
            self.retryButtonCompletion = retryButtonCompletion
        default:
            return
        }
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
