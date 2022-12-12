//
//  BinanceOrderType.swift
//  
//
//  Created by Fernando Fernandes on 12.12.22.
//

import Foundation

public enum BinanceOrderType: String, Codable {
    case limit
    case limitMaker         = "LIMIT_MAKER"
    case market
    case stopLoss           = "STOP_LOSS"
    case stopLossLimit      = "STOP_LOSS_LIMIT"
    case takeProfit         = "TAKE_PROFIT"
    case takeProfitLimit    = "TAKE_PROFIT_LIMIT"
}
