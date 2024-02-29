//
//  TrendingView.swift
//  CryptoCoin
//
//  Created by 권현석 on 2/28/24.
//

import UIKit
import RxDataSources

final class TrendingView: BaseView {
    
    private let viewTitleLabel = {
        let view = UILabel()
        view.text = "Crypto Coin"
        view.font = .systemFont(ofSize: 38,
                                weight: .bold)
        return view
    }()
    
    let trendingTableView = {
        let view = UITableView()
        view.showsVerticalScrollIndicator = false
        view.separatorStyle = .none
        view.register(FavoriteSectionTableViewCell.self,
                      forCellReuseIdentifier: FavoriteSectionTableViewCell.id)
        view.register(TrendingTableViewCell.self,
                      forCellReuseIdentifier: TrendingTableViewCell.id)
        return view
    }()
    
    override func configure() {
        super.configure()
        [
        viewTitleLabel,
        trendingTableView
        ].forEach { addSubview($0) }
    }
    
    override func setConstrinats() {
        viewTitleLabel.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview().inset(12)
        }
        
        trendingTableView.snp.makeConstraints {
            $0.top.equalTo(viewTitleLabel.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
}
