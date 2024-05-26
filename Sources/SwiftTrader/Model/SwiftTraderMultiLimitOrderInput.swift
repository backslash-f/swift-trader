//
//  SwiftTraderMultiLimitOrderInput.swift
//
//
//  Created by Fernando Fernandes on 25.05.24.
//

import Foundation

/// Encapsulates all the arguments required for submiting multiple limit orders at once to supported exchanges.
public struct SwiftTraderMultiLimitOrderInput {

    // MARK: - Properties

    public let symbol: String
    public let maxBid: String
    public let initialPriceIncrement: Double
    public let priceIncrement: Double
    public let totalFunds: Double

    // MARK: - Lifecycle

    /// Creates a `SwiftTraderMultiLimitOrderInput` instance.
    ///
    /// Currently, only the following are supported/hardcoded:
    ///  - Kucoin exchange.
    ///  - Long+limit order types.
    ///  - Five orders at once.
    ///
    /// - Parameters:
    ///   - symbol: For example BTCUSDT
    ///   - maxBid: The maximum price offer for the asset so far. For example "68833.24"
    ///   - initialPriceIncrement: The price of the first order, based on the `maxBid`.
    ///   The value indicates the percentage. For example, 0,4 means that the price of the first order will
    ///   be 40% of the given `maxBid`.
    ///   - priceIncrement: How much the price of subsequent orders (second, third, fourth, and fifth) should go up.
    ///   The value indicates the percentage. For example: 0,1 = 10%.
    ///   - totalFunds: The total funds available for the operation. The number will be distributed evenly
    ///   between all submitted orders.
    public init(symbol: String,
                maxBid: String,
                initialPriceIncrement: Double,
                priceIncrement: Double,
                totalFunds: Double) {
        self.symbol = symbol
        self.maxBid = maxBid
        self.initialPriceIncrement = initialPriceIncrement
        self.priceIncrement = priceIncrement
        self.totalFunds = totalFunds
    }
}
