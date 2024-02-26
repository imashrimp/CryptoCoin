//
//  SearchCoinViewModel.swift
//  CryptoCoin
//
//  Created by 권현석 on 2/26/24.
//

import Foundation
import RxSwift
import RxCocoa

final class SearchCoinViewModel {
    
    private let coinSearchRepository = CoinSearchRepository()
    private let disposeBag = DisposeBag()
    
    let output = Output()
    
    struct Input {
        let searchWord: ControlProperty<String>
        let searchButtonTapped: ControlEvent<Void>
//        let likeButtonTapped: ControlEvent<Void>
        let cellDidSelected: ControlEvent<SearchedCoinEntity>
    }
    
    struct Output {
        let searchedCoinList = BehaviorSubject<[SearchedCoinEntity]>(value: [])
        let searchKeyword = BehaviorRelay<String>(value: "")
        let showCoinChart = PublishSubject<String>()
    }
    
    struct entityModel {
        let data: [SearchedCoinEntity]
        let stringtext: String
    }
    
    init() {
        
    }
    
    func transform(input: Input) {
        
        let searchKeyword = BehaviorRelay(value: "")
        let networkResult = PublishRelay<[SearchedCoinEntity]>()
        
        input.searchButtonTapped
            .withLatestFrom(input.searchWord)
            .distinctUntilChanged()
            .map{
                searchKeyword.accept($0)
                return CoinSearchRequestModel(query: $0)
            }
            .flatMap { NetworkManager.getSearchedCoinList(query: $0) }
            .bind(with: self) { owner, value in
                owner.output.searchedCoinList.onNext(value)
            }
            .disposed(by: disposeBag)
            
        
        searchKeyword.bind(with: self) { owner, value in
            owner.output.searchKeyword.accept(value)
        }
        .disposed(by: disposeBag)
        
        
        input
            .cellDidSelected
            .bind(with: self) { owner, coinData in
                owner.output.showCoinChart.onNext(coinData.id)
            }
            .disposed(by: disposeBag)
    }
    
}
