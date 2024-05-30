//
//  SwiftTraderMultiLongLimitOrderInput.swift
//
//
//  Created by Fernando Fernandes on 25.05.24.
//

import Foundation

/// Encapsulates all the arguments required for submiting multiple limit orders at once to supported exchanges.
public struct SwiftTraderMultiLongLimitOrderInput {

    // MARK: - Properties

    public let symbol: String
    public let initialPrice: String
    public let initialPriceIncrement: Double
    public let priceIncrement: Double
    public let totalFunds: Double

    // MARK: - Lifecycle

    /// Creates a `SwiftTraderMultiLongLimitOrderInput` instance.
    ///
    /// - Note: Currently, only the following are supported/hardcoded:
    /// Kucoin exchange, buy/limit orders and five orders at once.
    ///
    /// - Parameters:
    ///   - symbol: For example BTCUSDT
    ///   - initialPrice: The asset price from where the calculations should begin, for example "68833.24".
    ///   - initialPriceIncrement: The price of the first order, based on the `initialPrice`.
    ///   The value indicates the percentage. For example, 0,4 means that the price of the first order will
    ///   be 40% of the given `initialPrice`.
    ///   - priceIncrement: How much the price of subsequent orders (second, third, fourth, and fifth) should go up.
    ///   The value indicates the percentage. For example: 0,1 = 10%.
    ///   - totalFunds: The total funds available for the operation. The number will be distributed evenly
    ///   between all submitted orders.
    public init(symbol: String,
                initialPrice: String,
                initialPriceIncrement: Double,
                priceIncrement: Double,
                totalFunds: Double) {
        self.symbol = symbol
        self.initialPrice = initialPrice
        self.initialPriceIncrement = initialPriceIncrement
        self.priceIncrement = priceIncrement
        self.totalFunds = totalFunds
    }
}
