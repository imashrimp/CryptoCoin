//
//  NetworkStatus.swift
//  CryptoCoin
//
//  Created by 권현석 on 3/4/24.
//

import Alamofire
import Foundation
import RxSwift


final class NetworkStatus: NSObject {
    
    static let shared = NetworkStatus()
    
    fileprivate let behaviorPublish = BehaviorSubject<NetworkStatusType>(value: .connect)
    
    var statusObservable: Observable<NetworkStatusType> {
        behaviorPublish
            .debug()
    }
    
    private override init() {
        super.init()
        observeReachability()
    }
    
    private func observeReachability() {
        let reachability = NetworkReachabilityManager()
        reachability?.startListening(onUpdatePerforming: { [weak behaviorPublish] status in
            switch status {
            case .notReachable:
                behaviorPublish?.onNext(.disconnect)
            case .reachable(.ethernetOrWiFi), .reachable(.cellular):
                behaviorPublish?.onNext(.connect)
            case .unknown:
                behaviorPublish?.onNext(.unknown)
            }
        })
    }
}
