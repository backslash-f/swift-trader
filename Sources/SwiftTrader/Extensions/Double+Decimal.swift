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
    
    /// Returns the decimal numbers of `self`.
    ///
    /// Examples:
    ///  - 43865.52: returns "2"
    ///  - 0.934: returns "3"
    ///  - 0.00003456: returns "8"
    ///  - 2: returns "0"
    func decimalCount() -> Int {
        if self == Double(Int(self)) {
            return 0
        }
        let integerString = "\(NSNumber(value: Int(self)).decimalValue)"
        let doubleString = Double(self).toDecimalString()
        let decimalCount = doubleString.count - integerString.count - 1
        return decimalCount
    }
}
