//
//  KucoinAuth.swift
//
//
//  Created by Fernando Fernandes on 29.01.22.
//

import Foundation

/// Holds data required to authenticate requests against Kucoin APIs.
public struct KucoinAuth {

    public let spot: KucoinAuthorizing
    public let futures: KucoinAuthorizing

    public init(spot: KucoinAuthorizing, futures: KucoinAuthorizing) {
        self.spot = spot
        self.futures = futures
    }
}

public extension KucoinAuth {

    struct Spot: KucoinAuthorizing, Codable {
        public let apiKey: String
        public let apiSecret: String
        public let apiPassphrase: String

        public init(apiKey: String, apiSecret: String, apiPassphrase: String) {
            self.apiKey = apiKey
            self.apiSecret = apiSecret
            self.apiPassphrase = apiPassphrase
        }
    }

    struct Futures: KucoinAuthorizing, Codable {
        public let apiKey: String
        public let apiSecret: String
        public let apiPassphrase: String

        public init(apiKey: String, apiSecret: String, apiPassphrase: String) {
            self.apiKey = apiKey
            self.apiSecret = apiSecret
            self.apiPassphrase = apiPassphrase
        }
    }
}
