//
//  BaseView.swift
//  CryptoCoin
//
//  Created by 권현석 on 2/26/24.
//

import UIKit
import SnapKit

class BaseView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        setConstrinats()
    }
    
    func configure() {
        backgroundColor = UIColor(hexCode: ColorHexCode.white.colorCode)
    }
    
    func setConstrinats() {
        
    }
    
    @available (*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
