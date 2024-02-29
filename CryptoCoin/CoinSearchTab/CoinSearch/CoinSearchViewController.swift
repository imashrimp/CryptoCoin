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
        
        let coinData = PublishRelay<(AlertPresentEnum, SearchedCoinEntity)>()
        
        let input = SearchCoinViewModel.Input(searchWord: baseView.coinSearchBar.rx.text.orEmpty,
                                              searchButtonTapped: baseView.coinSearchBar.rx.searchButtonClicked,
                                              likeButtonTapped: likeButtonTappedCoin, 
                                              alertActionTapped: coinData,
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
        
        output
            .presentAlert
            .bind(with: self) { owner, value in
                switch value.0 {
                case .saveAlert:
                    owner.alert(
                        title: "\(value.1.name)코인을 즐겨찾기에 저장하시겠습니까?",
                        rightButtonTitle: "저장",
                        rightButtonHandler: { _ in
                            coinData.accept((AlertPresentEnum.saveAlert, value.1))
                        },
                        defaultButtonTitle: "취소")
                case .deleteAlert:
                    owner.alert(
                        title: "\(value.1.name)코인을 즐겨찾기에서 삭제하시겠습니까?",
                        rightButtonTitle: "삭제",
                        rightButtonStyle: .destructive,
                        rightButtonHandler: { _ in
                            coinData.accept((AlertPresentEnum.deleteAlert, value.1))
                        },
                        defaultButtonTitle: "취소")
                case .overLimit:
                    owner.alert(
                        title: "코인 즐겨찾기는 최대 10개까지 가능합니다",
                        rightButtonTitle: "확인",
                        rightButtonStyle: .default)
                }
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
                let vc = CoinChartViewController(viewModel: CoinChartViewModel(coinId: value))
                let backButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
                owner.navigationItem.backBarButtonItem = backButtonItem
                owner.navigationController?.pushViewController(vc,
                                                               animated: true)
            }
            .disposed(by: disposeBag)
        
        
    }
}
