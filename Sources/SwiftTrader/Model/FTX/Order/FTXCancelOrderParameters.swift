//
//  FTXCancelOrderParameters.swift
//  
//
//  Created by Fernando Fernandes on 09.03.22.
//

import Foundation

/// Encapsulates parameters do cancel an order, for example via `FTXCancelAllOrdersRequest`.
public struct FTXCancelOrderParameters {
    
    // MARK: - Properties
    
    /// Restrict to cancelling orders only on this market. E.g. "PAXG-PERP"
    public let market: String
    
    /// Restrict to cancelling orders only on this side.
    public let side: OrderSide
    
    /// Restrict to cancelling conditional orders only.
    public let conditionalOrdersOnly: Bool
    
    /// Restrict to cancelling existing limit orders (non-conditional orders) only.
    public let limitOrdersOnly: Bool
    
    // MARK: - Lifecycle
    
    public init(market: String,
                side: OrderSide,
                conditionalOrdersOnly: Bool,
                limitOrdersOnly: Bool) {
        self.market = market
        self.side = side
        self.conditionalOrdersOnly = conditionalOrdersOnly
        self.limitOrdersOnly = limitOrdersOnly
    }
}

/// Holds the keys of the parameters for cancelling a FTX trigger order.
public enum FTXCancelOrderParameterKey: String {
    case market
    case side
    case conditionalOrdersOnly
    case limitOrdersOnly
}
