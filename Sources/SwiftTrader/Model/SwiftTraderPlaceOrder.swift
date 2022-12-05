//
//  SwiftTraderPlaceOrder.swift
//  
//
//  Created by Fernando Fernandes on 05.12.22.
//

import Foundation

/// Encapsulates all the arguments required for submiting new orders to supported exchanges.
public struct SwiftTraderPlaceOrder {
    
    // MARK: - Properties
    
    public let symbol: String
    
    // MARK: - Lifecycle
    
    /// Creates a `SwiftTraderPlaceOrder` instance.
    ///
    /// - Parameters:
    ///   - symbol: E.g.: BTCUSDT
    public init(symbol: String) {
        self.symbol = symbol
    }
}
