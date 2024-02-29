//
//  TrendingViewModel.swift
//  CryptoCoin
//
//  Created by 권현석 on 2/28/24.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

final class TrendingViewModel {
    
    private let disposeBag = DisposeBag()
    
    private let savedCoinArr = BehaviorRelay<[SavedCoinEntity]>(value: [])
//    private let getTrendingData = BehaviorRelay<Void>(value: ())
    
    let output = Output()
    
    struct Input {
        
    }
    
    struct Output {
        let favoriteAndTrendItems = PublishRelay<[[PresentItemEntity]]>()
        let presentData = BehaviorRelay<[TrendEntity]>(value: [])
    }
    
    init(coinArr: [SavedCoinEntity]) {
        self.savedCoinArr.accept(coinArr)
    }
    
    func transform(input: Input) {
        
        savedCoinArr
            .filter { $0.count >= 2 }
            .map { $0.map { $0.coinID}.joined(separator: ",") }
            .map { FavoriteCoinsRequestModel(vs_currency: "krw", ids: $0) }
            .flatMap { NetworkManager.getFavoriteCoinArr(query: $0) }
            .bind(with: self) { owner, savedCoins in
                
                var result = [TrendEntity(
                    sectionTitle: "My Favorite",
                    data: savedCoins)]
                
                let trendResult = NetworkManager.getTrendingCoinList()
                trendResult
                    .bind(with: self) { owner, value in
                        result.append(contentsOf: value)
                        owner.output.presentData.accept(result)
                    }
                    .disposed(by: owner.disposeBag)
            }
            .disposed(by: disposeBag)
        
        
        savedCoinArr
            .filter { $0.count < 2 }
            .bind(with: self) { owner, _ in
                let trendResult = NetworkManager.getTrendingCoinList()
                trendResult
                    .bind(with: self) { owner, value in
                        owner.output.presentData.accept(value)
                    }
                    .disposed(by: owner.disposeBag)
            }
            .disposed(by: disposeBag)
    }
}
