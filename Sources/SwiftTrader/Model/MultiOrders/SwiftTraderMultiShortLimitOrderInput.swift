//
//  SwiftTraderMultiShortLimitOrderInput.swift
//
//
//  Created by Fernando Fernandes on 30.05.24.
//

import Foundation

/// Encapsulates all the arguments required for submiting multiple short limit orders at once to supported exchanges.
public struct SwiftTraderMultiShortLimitOrderInput {

    // MARK: - Properties

    public let symbol: String
    public let initialPrice: String
    public let targetProfitPercentage: Double
    public let priceDecrement: Double
    public let totalSize: Double

    // MARK: - Lifecycle

    /// Creates a `SwiftTraderMultiShortLimitOrderInput` instance.
    ///
    /// - Note: Currently, only the following are supported/hardcoded:
    /// Kucoin exchange, sell/limit orders, and five orders simultaneously.
    ///
    /// - Parameters:
    ///   - symbol: For example BTC-USDT
    ///   - initialPrice: The asset price from where the calculations should begin, for example, "68833.24".
    ///   - targetProfitPercentage: The price of the first order, based on the `initialPrice`.
    ///   The value indicates the percentage. For example, 0,4 means that the price of the first order will
    ///   be 40% of the given `initialPrice`.
    ///   - priceDecrement: How much the price of subsequent orders (second, third, fourth, and fifth)
    ///   should go **down**.
    ///   The value indicates the percentage. For example: 0,1 = 10%.
    ///   - totalSize: The total size available for the operation. The number will be distributed evenly
    ///   between all submitted orders.
    public init(symbol: String,
                initialPrice: String,
                targetProfitPercentage: Double,
                priceDecrement: Double,
                totalSize: Double) {
        self.symbol = symbol
        self.initialPrice = initialPrice
        self.targetProfitPercentage = targetProfitPercentage
        self.priceDecrement = priceDecrement
        self.totalSize = totalSize
    }
}
