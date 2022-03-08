//
//  KucoinOrderParameters.swift
//  
//
//  Created by Fernando Fernandes on 10.02.22.
//

import Foundation

/// Encapsulates parameters do place an order, for example via `KucoinFuturesPlaceOrdersRequest`.
///
/// https://docs.kucoin.com/futures/#place-an-order
public struct KucoinOrderParameters {
    
    // MARK: - Properties
    
    public let clientOid = UUID().uuidString
    public let symbol: String
    public let side: OrderSide
    public let type: KucoinOrderType
    public let stop: KucoinOrderStop
    public let stopPriceType: KucoinOrderStopPriceType
    public let stopPrice: String
    public let price: String
    public let reduceOnly: Bool
    public let closeOrder: Bool
    
    // MARK: - Lifecycle
    
    public init(symbol: String,
                side: OrderSide,
                type: KucoinOrderType,
                stop: KucoinOrderStop,
                stopPriceType: KucoinOrderStopPriceType,
                stopPrice: String,
                price: String,
                reduceOnly: Bool,
                closeOrder: Bool) {
        self.symbol = symbol
        self.side = side
        self.type = type
        self.stop = stop
        self.stopPriceType = stopPriceType
        self.stopPrice = stopPrice
        self.price = price
        self.reduceOnly = reduceOnly
        self.closeOrder = closeOrder
    }
}

/// Holds the keys of the parameters for placing a Kucoin order.
public enum KucoinOrderParameterKey: String {
    case clientOid
    case symbol
    case side
    case type
    case stop
    case stopPriceType
    case stopPrice
    case price
    case reduceOnly
    case closeOrder
}
