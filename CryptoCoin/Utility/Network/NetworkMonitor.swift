//
//  NetworkMonitor.swift
//  CryptoCoin
//
//  Created by 권현석 on 3/6/24.
//

import Foundation
import RxSwift
import Network

final class NetworkMonitor {
    static let shared = NetworkMonitor()
    private let queue = DispatchQueue.global(qos: .background)
    private let monitor: NWPathMonitor
    let networkConnected = BehaviorSubject<Bool?>(value: nil)
    
    init() {
        monitor = NWPathMonitor()
        dump(monitor)
        startMonitoring()
    }
    
    private func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                
                let networkStatus = path.status == .satisfied
                
                self?.networkConnected.onNext(networkStatus)
            }
        }
        monitor.start(queue: queue)
    }
    
    private func stopMonitoring() {
        monitor.cancel()
    }
}
