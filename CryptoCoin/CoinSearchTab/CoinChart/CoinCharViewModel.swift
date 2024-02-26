//
//  CoinCharViewModel.swift
//  CryptoCoin
//
//  Created by 권현석 on 2/26/24.
//

import Foundation
import RxSwift
import RxCocoa

final class CoinCharViewModel {
    
    private var disposeBag = DisposeBag()
    
    private let coinId = PublishSubject<String>()
    
    let output = Output()
    
    struct Input {
        let likeButtonTapped: ControlEvent<Void>
    }
    
    struct Output {
        let coinChartData = PublishSubject<CoinChartEntity>()
    }
    
    init(coinId: String) {
        self.coinId.onNext(coinId)
    }
    
    func transform(input: Input) {
        coinId
            .map { return CoinChartRequestModel(vs_currency: "krw", ids: $0) }
            .flatMap { NetworkManager.getCoinChartInfo(query: $0) }
            .bind(with: self) { owner, value in
                owner.output.coinChartData.onNext(value)
            }
            .disposed(by: disposeBag)
    }
}
