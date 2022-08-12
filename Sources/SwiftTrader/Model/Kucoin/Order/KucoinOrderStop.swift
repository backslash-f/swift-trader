//
//  KucoinOrderStop.swift
//  
//
//  Created by Fernando Fernandes on 10.02.22.
//

import Foundation

/// Futures: Either down or up.
/// Spot: Either loss or entry.
public enum KucoinOrderStop {

    public enum Futures: String {
        /// Triggers when the price reaches or goes below a stop price.
        case down
        /// Triggers when the price reaches or goes above the a stop price.
        case up
    }

    public enum Spot: String {
        /// Triggers when the last trade price changes to a value at or below the stop price.
        case loss
        /// Triggers when the last trade price changes to a value at or above the stop price.
        case entry
    }
}
