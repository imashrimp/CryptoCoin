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
    
    private let disposeBag = DisposeBag()
    
    let output = Output()
    
    struct Input {
        let searchWord: ControlProperty<String>
        let searchButtonTapped: ControlEvent<Void>
//        let likeButtonTapped: ControlEvent<Void>
    }
    
    struct Output {
        let searchedCoinList = BehaviorSubject<[SearchedCoinEntity]>(value: [])
    }
    
    init() {
        
    }
    
    func transform(input: Input) {
        input.searchButtonTapped
            .withLatestFrom(input.searchWord)
            .map{ CoinSearchRequestModel(query: $0) }
            .flatMap { NetworkManager.getSearchedCoinList(query: $0) }
            .bind(with: self) { owner, value in
                owner.output.searchedCoinList.onNext(value)
            }
            .disposed(by: disposeBag)
        
    }
    
}
