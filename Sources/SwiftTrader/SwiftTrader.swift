//
//  SwiftTrader.swift
//
//
//  Created by Fernando Fernandes on 24.01.22.
//

/// Entry point for connecting and trading on crypto exchanges such as Binance and Kucoin.
public struct SwiftTrader {
    
    // MARK: - Properties
    
    public let kucoinAuth: KucoinAuth
    
    // MARK: - Lifecycle
    
    public init(kucoinAuth: KucoinAuth) {
        self.kucoinAuth = kucoinAuth
    }
}

// MARK: - Interface

public extension SwiftTrader {
    
    #warning("TODO: create a SwiftTraderResult")
    func kucoinFuturesAccountOverview() async throws -> NetworkRequestResult {
        await KucoinAccountOverviewRequest(kucoinAuth: kucoinAuth).execute()
    }
}
