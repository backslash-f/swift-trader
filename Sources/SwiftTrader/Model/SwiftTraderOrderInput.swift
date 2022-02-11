//
//  SwiftTraderOrderInput.swift
//  
//
//  Created by Fernando Fernandes on 11.02.22.
//

import Foundation

/// Encapsulates all the arguments required for submiting orders to supported exchanges.
public struct SwiftTraderOrderInput {
    
    // MARK: - Properties
    
    public let exchange: SwiftTraderExchange
    public let ticker: String
    public let entryPrice: Double
    public let currentPrice: Double
    public let profitPercentage: Double
    public let offset: Double
    
    // MARK: - Lifecycle
    
    public init(exchange: SwiftTraderExchange,
                ticker: String,
                entryPrice: Double,
                currentPrice: Double,
                profitPercentage: Double,
                offset: Double) {
        self.exchange = exchange
        self.ticker = ticker
        self.entryPrice = entryPrice
        self.currentPrice = currentPrice
        self.profitPercentage = profitPercentage
        self.offset = offset
    }
}
