//
//  BinanceAuth.swift
//  
//
//  Created by Fernando Fernandes on 04.12.22.
//

import Foundation

public protocol BinanceAuthorizing {
    var apiKey: String { get }
    var apiSecret: String { get }
}

/// Holds data required to authenticate requests against Binance APIs.
public struct BinanceAuth {

    let spot: BinanceAuthorizing

    public init(spot: BinanceAuthorizing) {
        self.spot = spot
    }
}

public extension BinanceAuth {

    struct Spot: BinanceAuthorizing {
        public let apiKey: String
        public let apiSecret: String

        public init(apiKey: String, apiSecret: String) {
            self.apiKey = apiKey
            self.apiSecret = apiSecret
        }
    }
}

// MARK: - Equatable

extension BinanceAuth: Equatable {
    public static func == (lhs: BinanceAuth, rhs: BinanceAuth) -> Bool {
        lhs.spot.apiKey == rhs.spot.apiKey
    }
}
