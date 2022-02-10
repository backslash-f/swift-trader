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
    public let side: KucoinOrderSide
    public let symbol: String
    public let type: KucoinOrderType
    public let stop: KucoinOrderStop
    public let stopPriceType: KucoinOrderStopPriceType
    public let stopPrice: String
    public let reduceOnly: Bool
    public let closeOrder: Bool
    public let price: String
    
    // MARK: - Lifecycle
    
    public init(side: KucoinOrderSide,
                symbol: String,
                type: KucoinOrderType,
                stop: KucoinOrderStop,
                stopPriceType: KucoinOrderStopPriceType,
                stopPrice: String,
                reduceOnly: Bool,
                closeOrder: Bool,
                price: String) {
        self.side = side
        self.symbol = symbol
        self.type = type
        self.stop = stop
        self.stopPriceType = stopPriceType
        self.stopPrice = stopPrice
        self.reduceOnly = reduceOnly
        self.closeOrder = closeOrder
        self.price = price
    }
}

/// Holds the keys of the parameters for placing a Kucoin order.
public enum KucoinOrderParameterKey: String {
    case clientOid
    case side
    case symbol
    case type
    case stop
    case stopPriceType
    case stopPrice
    case reduceOnly
    case closeOrder
    case price
}
