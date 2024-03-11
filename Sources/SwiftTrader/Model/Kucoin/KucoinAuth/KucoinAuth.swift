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

    public static func empty() -> KucoinAuth {
        KucoinAuth(
            spot: KucoinAuth.Spot.empty(),
            futures: KucoinAuth.Futures.empty()
        )
    }
}

