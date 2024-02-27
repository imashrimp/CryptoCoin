//
//  CoinCharViewModel.swift
//  CryptoCoin
//
//  Created by 권현석 on 2/26/24.
//

import Foundation
import RxSwift
import RxCocoa

final class CoinChartViewModel {
    
    private var disposeBag = DisposeBag()
    
    private let coinId = BehaviorSubject<String?>(value: nil)
    
    let output = Output()
    
    struct Input {
//        let likeButtonTapped: ControlEvent<Void>
    }
    
    struct Output {
        let coinChartData = PublishSubject<CoinChartEntity>()
        let priceChangePercentLabelTextColor = PublishSubject<Bool>()
    }
    
    init(coinId: String) {
        self.coinId.onNext(coinId)
    }
    
    func transform(input: Input) {
        coinId
            .map{
                guard let coinId = $0 else { return "" }
                return coinId
            }
            .map { return CoinChartRequestModel(vs_currency: "krw", ids: $0, sparkline: "true" ) }
            .flatMap { NetworkManager.getCoinChartInfo(query: $0) }
            .bind(with: self) { owner, value in
                owner.output.coinChartData.onNext(value)
                
                let plusOrMinus = value.priceChangePercentage24H.prefix(1)
                
                if plusOrMinus == "-" {
                    owner.output.priceChangePercentLabelTextColor.onNext(false)
                } else {
                    owner.output.priceChangePercentLabelTextColor.onNext(true)
                }
                
            }
            .disposed(by: disposeBag)
    }
}
