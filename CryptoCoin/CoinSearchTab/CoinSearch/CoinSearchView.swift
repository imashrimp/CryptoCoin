//
//  CoinSearchView.swift
//  CryptoCoin
//
//  Created by 권현석 on 2/26/24.
//

import UIKit

final class CoinSearchView: BaseView {
    
    let viewTitleLabel = {
        let view = UILabel()
        view.text = "Search"
        view.font = .systemFont(ofSize: 38,
                                weight: .bold)
        return view
    }()
    
    let coinSearchBar = {
        let view = UISearchBar()
        view.backgroundImage = UIImage()
        view.placeholder = "코인명 또는 심볼 검색"
        return view
    }()
    
    lazy var searchCoinTableView = {
        let view = UITableView()
        view.showsVerticalScrollIndicator = false
        view.separatorStyle = .none
        view.register(SearchedCoinTableViewCell.self,
                      forCellReuseIdentifier: SearchedCoinTableViewCell.id)
        view.keyboardDismissMode = .onDrag
        return view
    }()
    
    override func configure() {
        super.configure()
        [
        viewTitleLabel,
        coinSearchBar,
        searchCoinTableView
        ].forEach { addSubview($0) }
    }
    
    override func setConstrinats() {
        viewTitleLabel.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview().inset(12)
        }
        
        coinSearchBar.snp.makeConstraints {
            $0.top.equalTo(viewTitleLabel.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
        }
        
        searchCoinTableView.snp.makeConstraints {
            $0.top.equalTo(coinSearchBar.snp.bottom)
            $0.horizontalEdges.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
}
