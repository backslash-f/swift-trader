//
//  KucoinOrderType.swift
//  
//
//  Created by Fernando Fernandes on 05.02.22.
//

import Foundation

public enum KucoinOrderType: String, Codable {
    case limit
    case market
    case limitStop = "limit_stop"
    case marketStop = "market_stop"
}
