//
//  Double+Decimal.swift
//  
//
//  Created by Fernando Fernandes on 11.02.22.
//

import Foundation

public extension Double {

    /// Returns the decimal value of `self` **without** scientific notation (e.g.: "1.2e-6").
    func toDecimalString() -> String {
        "\(NSNumber(value: Double(self)).decimalValue)"
    }
}
