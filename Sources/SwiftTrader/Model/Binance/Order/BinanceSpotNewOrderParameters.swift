//
//  BinanceSpotNewOrderParameters.swift
//  
//
//  Created by Fernando Fernandes on 04.12.22.
//

import Foundation

/// Encapsulates parameters to place a spot order.
///
/// https://binance-docs.github.io/apidocs/spot/en/#new-order-trade
public struct BinanceSpotNewOrderParameters {
    
    // MARK: - Properties
    
    public let symbol: String
    public let side: OrderSide
    public let type: BinanceOrderType
    public let quoteOrderQty: Double
    
    // MARK: - Lifecycle
    
    public init(symbol: String,
                side: OrderSide,
                type: BinanceOrderType,
                quoteOrderQty: Double) {
        self.symbol = symbol
        self.side = side
        self.type = type
        self.quoteOrderQty = quoteOrderQty
    }
}

/// Holds the keys of the parameters for placing a new Binance order.
public enum BinanceSpotNewOrderParameterKey: String {
    case symbol
    case side
    case type
    case quoteOrderQty
}
