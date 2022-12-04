//
//  BinanceSpotOrderParameters.swift
//  
//
//  Created by Fernando Fernandes on 04.12.22.
//

import Foundation

/// Encapsulates parameters to place a spot order.
///
/// https://binance-docs.github.io/apidocs/spot/en/#new-order-trade
public struct BinanceSpotOrderParameters {
    
    // MARK: - Properties
    
    public let symbol: String
    
    // MARK: - Lifecycle
    
    public init(symbol: String) {
        self.symbol = symbol
    }
}

/// Holds the keys of the parameters for placing a Binance order.
public enum BinanceOrderParameterKey: String {
    case symbol
}
