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
        
    }
    
    struct Output {
        
    }
    
    init(coinId: String) {
        self.coinId.onNext(coinId)
    }
    
    func transform(input: Input) {
        coinId.bind(with: self) { owner, value in
            
        }
        .disposed(by: disposeBag)
    }
}
