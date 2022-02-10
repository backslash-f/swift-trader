//
//  KucoinOrderStop.swift
//  
//
//  Created by Fernando Fernandes on 10.02.22.
//

import Foundation

/// Either down or up.
public enum KucoinOrderStop: String {
    
    /// Triggers when the price reaches or goes below a stop price.
    case down

    /// Triggers when the price reaches or goes above the a stop price.
    case up
}
