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
    
    public let exchange: SwiftTraderExchange
    public let ticker: String
    public let tickerSize: String
    public let contractSymbol: String
    public let entryPrice: Double
    public let currentPrice: Double
    public let profitPercentage: Double
    public let offset: Double
    public let clean: Bool
    
    // MARK: - Lifecycle
    
    /// Creates a `SwiftTraderOrderInput` instance.
    ///
    /// - Parameters:
    ///   - exchange: E.g.: Kucoin, Binance
    ///   - ticker: E.g.: BTCUSDT
    ///   - tickerSize: E.g.: "1", "0.05", "0.00001"
    ///   - contractSymbol: E.g.: XBTCUSDTM
    ///   - entryPrice: E.g.: "42.856", "43567.98", "127.01".
    ///   - currentPrice: The current price of the asset.
    ///   - profitPercentage: The percentage of the profit at this point, e.g.: "1.5", "0.67".
    ///   - offset: How far the **"target price"** of the stop order will be from the `currentPrice`. For example,
    ///   suppose the `profitPercentage` is `1.0%` and the `offset` is `0.75%`. The stop order to be placed will be `0.25%`
    ///   of the current price (`1.0%` - `0.75%`). Using the same `offset`, if the `profitPercentage` is now `2.0%`, the stop order
    ///   will be placed at `1.25%` of the current price (`2.0%` - `0.75%`).
    ///   - clean: When `true`, all the untriggered stop orders for the `contractSymbol` will be cancelled before placing a new one.
    ///   Cleaning is done via `SwiftTrader.kucoinFuturesCancelStopOrders(symbol:)`. In case that fails, the execution continues
    ///   and a new order will be placed regardless.
    public init(exchange: SwiftTraderExchange,
                ticker: String,
                tickerSize: String,
                contractSymbol: String,
                entryPrice: Double,
                currentPrice: Double,
                profitPercentage: Double,
                offset: Double,
                clean: Bool) {
        self.exchange = exchange
        self.ticker = ticker
        self.tickerSize = tickerSize
        self.contractSymbol = contractSymbol
        self.entryPrice = entryPrice
        self.currentPrice = currentPrice
        self.profitPercentage = profitPercentage
        self.offset = offset
        self.clean = clean
    }
}
