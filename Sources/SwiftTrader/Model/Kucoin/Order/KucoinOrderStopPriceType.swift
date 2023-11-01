//
//  KucoinOrderStopPriceType.swift
//  
//
//  Created by Fernando Fernandes on 10.02.22.
//

import Foundation

/// Either `TP`, `IP` or `MP`.
///
/// Need to be defined if `KucoinOrderStop` is specified.
public enum KucoinOrderStopPriceType: String {

    /// Trade price.
    case TP

    /// Index price
    case IP

    /// Mark price.
    case MP
}
