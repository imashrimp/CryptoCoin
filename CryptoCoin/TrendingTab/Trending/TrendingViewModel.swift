//
//  TrendingViewModel.swift
//  CryptoCoin
//
//  Created by 권현석 on 2/28/24.
//

import Foundation
import RxSwift
import RxCocoa

final class TrendingViewModel {
    
    private let disposeBag = DisposeBag()
    private let repository = CoinRepository()
    
    private let savedCoinArr = BehaviorSubject<[SavedCoinEntity]>(value: [])
    
    let output = Output()
    
    struct Input {
        let itemDidSelect: PublishRelay<(String)>
        let updateFavoriteCoinList: PublishRelay<Void>
    }
    
    struct Output {
        let favoriteAndTrendItems = PublishRelay<[[PresentItemEntity]]>()
        let presentData = BehaviorRelay<[TrendEntity]>(value: [])
        let pushToChart = PublishRelay<String>()
        let networkError = PublishSubject<String>()
    }
    
    init(coinArr: [SavedCoinEntity]) {
        self.savedCoinArr.onNext(coinArr)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateCoinListNoti),
                                               name: NSNotification.Name(NotificationName.searchViewNoti.rawValue),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateCoinListNoti),
                                               name: NSNotification.Name(NotificationName.favoriteChartViewNoti.rawValue),
                                               object: nil)
    }
    
    func transform(input: Input) {
        
        /// 기본적 구조는 주입 받은 coinID 배열을 통해 통신 분기처리를 할 것이며
        /// 이 데이터와 무관하게 Trend 데이터는 받야야함
        /// 그렇다면 주입받은 coinID 수와 무관하게 이를 호출해서 combineLastest 등으로 테이블 뷰 다시 그리게

        savedCoinArr
            .filter { $0.count >= 2 }
            .map { $0.map { $0.coinID}.joined(separator: ",") }
            .map { FavoriteCoinsRequestModel(vs_currency: "krw", ids: $0) }
            .flatMap { NetworkManager.getFavoriteCoinArr(query: $0) }
            .bind(with: self) { owner, savedCoins in
                switch savedCoins {
                case .success(let data):
                    var result = [
                        TrendEntity(sectionTitle: "My Favorite",
                                    data: data)
                    ]
                    
                    let trendResult = NetworkManager.getTrendingCoinList().share()
                    trendResult
                        .bind(with: self) { owner, value in
                            switch value {
                            case .success(let data):
                                result.append(contentsOf: data)
                                owner.output.presentData.accept(result)
                            case .failure(let error):
                                owner.output.networkError.onNext(error.description)
                            }
                        }
                        .disposed(by: owner.disposeBag)
                    
                case .failure(let error):
                    owner.output.networkError.onNext(error.description)
                }
                
                
            }
            .disposed(by: disposeBag)
        
        
        savedCoinArr
            .filter { $0.count < 2 }
            .bind(with: self) { owner, _ in
                let trendResult = NetworkManager.getTrendingCoinList()
                trendResult
                    .bind(with: self) { owner, value in
                        //                        owner.output.presentData.accept(value)
                        switch value {
                        case .success(let data):
                            owner.output.presentData.accept(data)
                        case .failure(let error):
                            owner.output.networkError.onNext(error.description)
                        }
                    }
                    .disposed(by: owner.disposeBag)
            }
            .disposed(by: disposeBag)
        
        input
            .itemDidSelect
            .filter { !$0.isEmpty }
            .bind(with: self) { owner, coinId in
                owner.output.pushToChart.accept(coinId)
            }
            .disposed(by: disposeBag)
        
        input
            .updateFavoriteCoinList
            .bind(with: self) { owner, _ in
                guard let savedCoinList = owner.repository?.readSavedCryptoCoinList() else { return }
                owner.savedCoinArr.onNext(savedCoinList)
            }
            .disposed(by: disposeBag)
    }
    
    @objc private func updateCoinListNoti() {
        guard let newCoinArr = repository?.readSavedCryptoCoinList() else { return }
        
        savedCoinArr.onNext(newCoinArr)
    }
}
