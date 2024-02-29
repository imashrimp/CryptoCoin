//
//  TrendingChartViewModel.swift
//  CryptoCoin
//
//  Created by 권현석 on 2/29/24.
//

import Foundation
import RxSwift
import RxCocoa

final class TrendingChartViewModel {
    
    private var disposeBag = DisposeBag()
    
    private let coinId = BehaviorRelay<String?>(value: nil)
    
    let output = Output()
    
    struct Output {
        let coinChartData = PublishSubject<CoinChartEntity>()
        let priceChangePercentLabelTextColor = PublishSubject<Bool>()
    }
    
    init(coinId: String) {
        self.coinId.accept(coinId)
    }
    
    func transform() {
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
