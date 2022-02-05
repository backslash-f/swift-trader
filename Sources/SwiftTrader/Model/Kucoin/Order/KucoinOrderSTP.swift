//
//  KucoinOrderSTP.swift
//  
//
//  Created by Fernando Fernandes on 05.02.22.
//

import Foundation

/// STP: Self-Trade Prevention - when specified and when placing orders, the order won't be matched by another one which is also yours.
/// On the contrary, if STP is not specified in advanced, your order can be matched by another one of your own orders.
/// It should be noted that only the taker's protection strategy is effective.
///
/// - CANCEL BOTH(CB)
/// - CANCEL NEWEST(CN)
/// - CANCEL OLDEST(CO)
/// - DECREMENT AND CANCEL(DC)
///
/// https://docs.kucoin.com/#matching-engine
public enum KucoinOrderSTP: String, Codable {
    case cancelBoth = "CB"
    case cancelNewest = "CN"
    case cancelOldest = "CO"
    case decrementCancel = "DC"
}
