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
}

public extension BinanceAuth {

    struct Spot: BinanceAuthorizing, Codable {
        public let apiKey: String
        public let apiSecret: String

        public init(apiKey: String, apiSecret: String) {
            self.apiKey = apiKey
            self.apiSecret = apiSecret
        }
    }
}
