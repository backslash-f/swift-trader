//
//  SwiftTraderExchange.swift
//
//
//  Created by Fernando Fernandes on 16.01.22.
//

import Foundation

/// The list of supported exchanges.
public enum SwiftTraderExchange: String, Codable {
    case binance
    case ftx
    case kucoin
}
