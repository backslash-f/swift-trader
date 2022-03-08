//
//  FTXOrderParameters.swift
//  
//
//  Created by Fernando Fernandes on 08.03.22.
//

import Foundation

/// Encapsulates parameters do place an order, for example via `FTXPlaceOrderRequest`.
public struct FTXTriggerOrderParameters {
    
    // MARK: - Properties
    
    public let market: String
    public let side: OrderSide
    public let size: Double
    public let type: FTXTTriggerOrderType
    public let reduceOnly: Bool
    public let retryUntilFilled: Bool
    public let triggerPrice: Double
    public let orderPrice: Double
    
    // MARK: - Lifecycle
    
    public init(market: String,
                side: OrderSide,
                size: Double,
                type: FTXTTriggerOrderType,
                reduceOnly: Bool,
                retryUntilFilled: Bool,
                triggerPrice: Double,
                orderPrice: Double) {
        self.market = market
        self.side = side
        self.size = size
        self.type = type
        self.reduceOnly = reduceOnly
        self.retryUntilFilled = retryUntilFilled
        self.triggerPrice = triggerPrice
        self.orderPrice = orderPrice
    }
}

/// Holds the keys of the parameters for placing a FTX trigger order.
public enum FTXTriggerOrderParameterKey: String {
    case market
    case side
    case size
    case type
    case reduceOnly
    case retryUntilFilled
    case triggerPrice
    case orderPrice
}
