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
        let searchKeyword = PublishSubject<String>()
        let showCoinChart = PublishSubject<String>()
    }
    
    init() {
        
    }
    
    func transform(input: Input) {
        
        let searchKeyword = PublishSubject<String>()
        
        input.searchButtonTapped
            .withLatestFrom(input.searchWord)
            .distinctUntilChanged()
            .map{
                searchKeyword.onNext($0)
                return CoinSearchRequestModel(query: $0)
            }
            .flatMap { NetworkManager.getSearchedCoinList(query: $0) }
            .bind(with: self) { owner, value in
                
                //통신을 통해 가져온 값을 [coinId: coinData]타입의 딕셔너리로 변환 후
                //Realm에 저장된 데이터도 읽어와 중복된 coinID가 있는 경우 이를 가장 앞으로 보내서 배열을 제 정렬함
//                let savedCoinData = owner.coinSearchRepository?.readSavedCryptoCoinList()
                
//                value.filter { <#SearchedCoinEntity#> }
                
                owner.output.searchedCoinList.onNext(value)
            }
            .disposed(by: disposeBag)
        
        searchKeyword.bind(with: self) { owner, value in
            owner.output.searchKeyword.onNext(value)
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
