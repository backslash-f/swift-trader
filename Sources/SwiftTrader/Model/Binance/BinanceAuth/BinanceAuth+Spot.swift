//
//  BinanceAuth+Spot.swift
//
//
//  Created by Fernando Fernandes on 07.03.24.
//

import Foundation

public extension BinanceAuth {

    struct Spot: BinanceAuthorizing, Codable, Equatable {
        public let apiKey: String
        public let apiSecret: String

        public init(apiKey: String, apiSecret: String) {
            self.apiKey = apiKey
            self.apiSecret = apiSecret
        }

        public static func empty() -> BinanceAuth.Spot {
            BinanceAuth.Spot(apiKey: "", apiSecret: "")
        }
    }
}

