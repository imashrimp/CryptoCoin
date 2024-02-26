//
//  ViewModelProtocol.swift
//  CryptoCoin
//
//  Created by 권현석 on 2/26/24.
//

import Foundation

protocol ViewModelProtocol {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input)
}
