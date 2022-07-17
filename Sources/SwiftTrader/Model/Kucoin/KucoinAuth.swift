//
//  KucoinAuth.swift
//
//
//  Created by Fernando Fernandes on 29.01.22.
//

import Foundation

public protocol KucoinAuthorizing {
    var apiKey: String { get }
    var apiSecret: String { get }
    var apiPassphrase: String { get }
}

/// Holds data required to authenticate requests against Kucoin APIs.
public struct KucoinAuth {
    
    let spot: KucoinAuthorizing
    let futures: KucoinAuthorizing
    
    public init(spot: KucoinAuthorizing, futures: KucoinAuthorizing) {
        self.spot = spot
        self.futures = futures
    }
}

public extension KucoinAuth {
    
    struct Spot: KucoinAuthorizing {
        public let apiKey: String
        public let apiSecret: String
        public let apiPassphrase: String
        
        public init(apiKey: String, apiSecret: String, apiPassphrase: String) {
            self.apiKey = apiKey
            self.apiSecret = apiSecret
            self.apiPassphrase = apiPassphrase
        }
    }
    
    struct Futures: KucoinAuthorizing {
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
