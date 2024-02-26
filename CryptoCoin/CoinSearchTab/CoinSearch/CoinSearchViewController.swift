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
        
        let likeButtonTappedCoin = PublishRelay<SearchedCoinEntity>()
        
        let input = SearchCoinViewModel.Input(searchWord: baseView.coinSearchBar.rx.text.orEmpty,
                                              searchButtonTapped: baseView.coinSearchBar.rx.searchButtonClicked,
                                              likeButtonTappedCoin: likeButtonTappedCoin,
                                              cellDidSelected: baseView.searchCoinTableView.rx.modelSelected(SearchedCoinEntity.self))
        
        seachViewModel.transform(input: input)
        
        let output = seachViewModel.output
        
        output
            .searchedCoinList
            .bind(to: baseView.searchCoinTableView
                .rx
                .items(cellIdentifier: SearchedCoinTableViewCell.id,
                       cellType: SearchedCoinTableViewCell.self)) { (row, element, cell) in
                cell.showContents(keyword: output.searchKeyword.value, data: element)
                cell.likeButton.rx.tap
                    .bind{ likeButtonTappedCoin.accept(element)}
                    .disposed(by: cell.disposeBag)
                }
                       .disposed(by: disposeBag)
        
        output.likeButtonTappedCoin
            .bind(with: self) { owner, _ in
                owner.baseView.searchCoinTableView.reloadData()
            }
            .disposed(by: disposeBag)
        
        output
            .transitionToCoinChartView
            .bind(with: self) { owner, value in
                let vc = CoinChartViewController(viewModel: CoinCharViewModel(coinId: value))
                owner.navigationController?.pushViewController(vc,
                                                               animated: true)
            }
            .disposed(by: disposeBag)
        
        
    }
}
