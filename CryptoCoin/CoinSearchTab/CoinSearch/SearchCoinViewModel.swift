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
    
    private let coinSearchRepository = CoinRepository()
    private let disposeBag = DisposeBag()
    
    let output = Output()
    
    struct Input {
        let searchWord: ControlProperty<String>
        let searchButtonTapped: ControlEvent<Void>
        let likeButtonTappedCoin: PublishRelay<SearchedCoinEntity>
        let cellDidSelected: ControlEvent<SearchedCoinEntity>
    }
    
    struct Output {
        let searchedCoinList = BehaviorSubject<[SearchedCoinEntity]>(value: [])
        let searchKeyword = BehaviorRelay<String>(value: "")
        let transitionToCoinChartView = PublishSubject<String>()
        let likeButtonTappedCoin = PublishSubject<Void>()
        let alreadySavedTenCoins = PublishRelay<Void>()
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
                networkResult.accept(value)
            }
            .disposed(by: disposeBag)
        
        
        searchKeyword.bind(with: self) { owner, value in
            owner.output.searchKeyword.accept(value)
        }
        .disposed(by: disposeBag)
        
        networkResult.bind(with: self) { owner, value in
            owner.output.searchedCoinList.onNext(value)
        }
        .disposed(by: disposeBag)
        
        input
            .likeButtonTappedCoin
            .bind(with: self) { owner, value in
                
                guard let saveState = owner.coinSearchRepository?.checkCoinSaveState(coinId: value.id),
                      let savedCoinCount = owner.coinSearchRepository?.readSavedCryptoCoinList().count else {
                    return
                }
                
                if saveState {
                    owner.coinSearchRepository?.deleteCryptoCoin(id: value.id)
                    owner.output.likeButtonTappedCoin.onNext(())
                } else {
                    if savedCoinCount < 10 {
                        owner.coinSearchRepository?.saveCryptoCoin(id: value.id)
                        owner.output.likeButtonTappedCoin.onNext(())
                    } else {
                        owner.output.alreadySavedTenCoins.accept(())
                    }
                }
            }
            .disposed(by: disposeBag)
        
        input
            .cellDidSelected
            .bind(with: self) { owner, coinData in
                owner.output.transitionToCoinChartView.onNext(coinData.id)
            }
            .disposed(by: disposeBag)
    }
    
}
