//
//  NetworkManager.swift
//  CryptoCoin
//
//  Created by 권현석 on 2/26/24.
//

import Foundation
import RxSwift

struct NetworkManager {
    
    static func getSearchedCoinList(query: CoinSearchRequestModel) -> Observable<[SearchedCoinEntity]> {
        
        return Observable<[SearchedCoinEntity]>.create { coinList in
            API.session.request(CryptoCoinListTarget.search(query))
                .validate(statusCode: 200...299)
                .responseDecodable(of: CoinSearchResponseModel.self) { response in
                    switch response.result {
                    case .success(let value):
                        let result = value.coins
                            .map { SearchedCoinEntity(id: $0.id, 
                                                      name: $0.name,
                                                      currencyUnit: $0.symbol,
                                                      logo: $0.large) }
                        
                        coinList.onNext(result)
                        
//                        coinList.onNext(value)
                    case .failure(let error):
                        //TODO: 에러핸들링 수정 필요
                        coinList.onError(error)
                    }
                }
            
            return Disposables.create()
        }
    }
}
