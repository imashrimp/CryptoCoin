//
//  CoinSearchViewController.swift
//  CryptoCoin
//
//  Created by 권현석 on 2/26/24.
//

import UIKit
import RxSwift
import RxCocoa

final class CoinSearchViewController: BaseViewController {

    private let baseView = CoinSearchView()
    private let seachViewModel: SearchCoinViewModel
    
    init(viewModel: SearchCoinViewModel) {
        self.seachViewModel = viewModel
        super.init()
    }
    
    override func loadView() {
        self.view = baseView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    private func bind() {
        let input = SearchCoinViewModel.Input(searchWord: baseView.coinSearchBar.rx.text.orEmpty,
                                              searchButtonTapped: baseView.coinSearchBar.rx.searchButtonClicked//,
                                              /*likeButtonTapped: <#T##ControlEvent<Void>#>*/)
        
        seachViewModel.transform(input: input)
        
        let output = seachViewModel.output
        
        output.searchedCoinList.bind(to: baseView.searchCoinTableView.rx.items(cellIdentifier: SearchedCoinTableViewCell.id,
                                                                               cellType: SearchedCoinTableViewCell.self)) { (row, element, cell) in
            
        }
                                                                               .disposed(by: disposeBag)
    }
}
