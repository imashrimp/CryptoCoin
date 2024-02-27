//
//  MainTabBarViewModel.swift
//  CryptoCoin
//
//  Created by 권현석 on 2/27/24.
//

import Foundation
import RxSwift
import RxCocoa

final class MainTabBarViewModel {

    private let coinRepository = CoinRepository()
    
    let output = Output()
    
    struct Output {
        let savedCoinArr = BehaviorRelay<[SavedCoinEntity]>(value: [])
    }
    
    init() {
        transform()
    }
    
    func transform() {
        guard let savedCoinArr = coinRepository?.readSavedCryptoCoinList() else { return }
        output.savedCoinArr.accept(savedCoinArr)
    }
}
