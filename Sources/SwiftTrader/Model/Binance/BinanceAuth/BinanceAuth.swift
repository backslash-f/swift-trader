//
//  BinanceAuth.swift
//  
//
//  Created by Fernando Fernandes on 04.12.22.
//

import Foundation

/// Holds data required to authenticate requests against Binance APIs.
public struct BinanceAuth {

    public let spot: BinanceAuthorizing

    public init(spot: BinanceAuthorizing) {
        self.spot = spot
    }

    public static func empty() -> BinanceAuth {
        BinanceAuth(spot: BinanceAuth.Spot.empty())
    }
}
