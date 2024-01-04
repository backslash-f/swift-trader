//
//  BinanceAuth+Equatable.swift
//  
//
//  Created by Fernando Fernandes on 03.01.24.
//

import Foundation

extension BinanceAuth: Equatable {

    public static func == (lhs: BinanceAuth, rhs: BinanceAuth) -> Bool {
        lhs.spot.apiKey == rhs.spot.apiKey &&
        lhs.spot.apiSecret == rhs.spot.apiSecret
    }
}
