//
//  SwiftTraderOrderInput.swift
//  
//
//  Created by Fernando Fernandes on 11.02.22.
//

import Foundation

/// Encapsulates all the arguments required for submiting stop limit orders to supported exchanges.
public struct SwiftTraderStopLimitOrderInput {

    // MARK: - Properties

    public let cancelStopOrders: Bool
    public let contractSymbol: String
    public let entryPrice: Double
    public let exchange: SwiftTraderExchange
    public let isLong: Bool
    public let offset: Double
    public let profitPercentage: Double
    public let size: Double
    public let ticker: String
    public let tickerSize: String

    // MARK: - Lifecycle

    /// Creates a `SwiftTraderOrderInput` instance.
    ///
    /// - Parameters:
    ///   - cancelStopOrders: When `true`, all the untriggered stop orders for the `contractSymbol` will be
    ///   cancelled before placing a new one. Cancelling is done via
    ///   `SwiftTrader.kucoinFuturesCancelStopOrders(symbol:)`. In case that fails, the execution continues
    ///   and a new order will be placed regardless.
    ///   - contractSymbol: E.g.: XBTCUSDTM
    ///   - entryPrice: E.g.: "42.856", "43567.98", "127.01".
    ///   - exchange: E.g.: Kucoin, Binance
    ///   - isLong: Indicates the side of the position. `true` indicates "long". `false` indicates "short".
    ///   The side is taken into consideration when performing trailing stop logic.
    ///   - offset: How far the **"target price"** of the stop order will be from the `entryPrice`. For example,
    ///   suppose the `profitPercentage` is `1.0%` and the `offset` is `0.75%`. The stop order to be placed
    ///   will be `0.25%` of the entry price (`1.0%` - `0.75%`). Using the same `offset`, if the `profitPercentage`
    ///   is now `2.0%`, the stop order will be placed at `1.25%` of the entry price (`2.0%` - `0.75%`).
    ///   - profitPercentage: The percentage of the profit at this point, e.g.: "1.5", "0.67".
    ///   - size: How much assets were bought.
    ///   - ticker: E.g.: BTCUSDT
    ///   - tickerSize: E.g.: "1", "0.05", "0.00001"
    public init(cancelStopOrders: Bool,
                contractSymbol: String,
                entryPrice: Double,
                exchange: SwiftTraderExchange,
                isLong: Bool,
                offset: Double,
                profitPercentage: Double,
                size: Double,
                ticker: String,
                tickerSize: String) {
        self.cancelStopOrders = cancelStopOrders
        self.contractSymbol = contractSymbol
        self.entryPrice = entryPrice
        self.exchange = exchange
        self.isLong = isLong
        self.offset = offset
        self.profitPercentage = profitPercentage
        self.size = size
        self.ticker = ticker
        self.tickerSize = tickerSize
    }
}
