//
//  SwiftTrader.swift
//
//
//  Created by Fernando Fernandes on 24.01.22.
//

import Foundation
import Logging

/// Entry point for connecting and trading on crypto exchanges such as Binance and Kucoin.
public struct SwiftTrader {
    
    // MARK: - Properties
    
    public let logger = SwiftTraderLogger()
    
    public let kucoinAuth: KucoinAuth?
    
    public let settings: SwiftTraderSettings
    
    // MARK: - Lifecycle
    
    public init(kucoinAuth: KucoinAuth?, settings: SwiftTraderSettings = DefaultSwiftTraderSettings()) {
        self.kucoinAuth = kucoinAuth
        self.settings = settings
    }
}
