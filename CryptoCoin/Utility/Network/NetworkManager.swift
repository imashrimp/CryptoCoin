//
//  NetworkManager.swift
//  CryptoCoin
//
//  Created by 권현석 on 2/26/24.
//

import Foundation
import RxSwift

struct NetworkManager {
    
    static func getTrendingCoinList() -> Observable<Result<[TrendEntity], NetworkError>> {

        return Observable<Result<[TrendEntity], NetworkError>>.create { trendData in
            API.session.request(CryptoCoinListTarget.trending)
                .validate(statusCode: 200...299)
                .responseDecodable(of: TrendingCoinResponseModel.self) { response in
                    switch response.result {
                    case .success(let value):
                        let result = value.toDomain()
                        trendData.onNext(.success(result))
                        
                    case .failure(let error):
                        let errorCode = error.responseCode ?? 0
                        
                        switch errorCode {
                        case 400:
                            trendData.onNext(.failure(NetworkError.badRequest))
                        case 401:
                            trendData.onNext(.failure(NetworkError.Unauthorised))
                        case 403:
                            trendData.onNext(.failure(NetworkError.forbidden))
                        case 429:
                            trendData.onNext(.failure(NetworkError.tooManyRequests))
                        default:
                            trendData.onNext(.failure(NetworkError.badRequest))
                        }
                    }
                }
            return Disposables.create()
        }
    }
    
    static func getSearchedCoinList(query: CoinSearchRequestModel) -> Observable<Result<[SearchedCoinEntity], NetworkError>> {
        
        return Observable<Result<[SearchedCoinEntity], NetworkError>>.create { coinList in
            API.session.request(CryptoCoinListTarget.search(query))
                .validate(statusCode: 200...299)
                .responseDecodable(of: CoinSearchResponseModel.self) { response in
                    switch response.result {
                    case .success(let value):
                        let result = value.toDomain()
                        coinList.onNext(.success(result))
                    case .failure(let error):
                        let errorCode = error.responseCode ?? 0
                        
                        switch errorCode {
                        case 400:
                            coinList.onNext(.failure(NetworkError.badRequest))
                        case 401:
                            coinList.onNext(.failure(NetworkError.Unauthorised))
                        case 403:
                            coinList.onNext(.failure(NetworkError.forbidden))
                        case 429:
                            coinList.onNext(.failure(NetworkError.tooManyRequests))
                        default:
                            coinList.onNext(.failure(NetworkError.badRequest))
                        }
                    }
                }
            
            return Disposables.create()
        }
    }
    
    static func getCoinChartInfo(query: CoinChartRequestModel) -> Observable<Result<CoinChartEntity, NetworkError>> {
        
        return Observable<Result<CoinChartEntity, NetworkError>>.create { coinChartInfo in
            API.session.request(CryptoCoinListTarget.coinChart(query))
                .validate(statusCode: 200...299)
                .responseDecodable(of: [CoinChartResponseModel].self) { response in
                    switch response.result {
                    case .success(let value):
                        let result = value.toDomain()
                        coinChartInfo.onNext(.success(result))
                    case .failure(let error):
                        let errorCode = error.responseCode ?? 0
                        
                        switch errorCode {
                        case 400:
                            coinChartInfo.onNext(.failure(NetworkError.badRequest))
                        case 401:
                            coinChartInfo.onNext(.failure(NetworkError.Unauthorised))
                        case 403:
                            coinChartInfo.onNext(.failure(NetworkError.forbidden))
                        case 429:
                            coinChartInfo.onNext(.failure(NetworkError.tooManyRequests))
                        default:
                            coinChartInfo.onNext(.failure(NetworkError.badRequest))
                        }
                    }
                }
            return Disposables.create()
        }
    }
    
    static func getFavoriteCoinArr(query: FavoriteCoinsRequestModel) -> Observable<Result<[PresentItemEntity], NetworkError>> {
        return Observable<Result<[PresentItemEntity], NetworkError>>.create { favoriteCoinArr in
            API.session.request(CryptoCoinListTarget.favoriteCoins(query))
                .validate(statusCode: 200...299)
                .responseDecodable(of: [FavoriteCoinInfoResponseModel].self) { response in
                    switch response.result {
                    case .success(let value):
                        let result = value.toDomain()
                        favoriteCoinArr.onNext(.success(result))
                        
                    case .failure(let error):
                        let errorCode = error.responseCode ?? 0
                        
                        switch errorCode {
                        case 400:
                            favoriteCoinArr.onNext(.failure(NetworkError.badRequest))
                        case 401:
                            favoriteCoinArr.onNext(.failure(NetworkError.Unauthorised))
                        case 403:
                            favoriteCoinArr.onNext(.failure(NetworkError.forbidden))
                        case 429:
                            favoriteCoinArr.onNext(.failure(NetworkError.tooManyRequests))
                        default:
                            favoriteCoinArr.onNext(.failure(NetworkError.badRequest))
                        }
                    }
                }
            return Disposables.create()
        }
    }
}
