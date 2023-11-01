//
//  String+Decimal.swift
//  
//
//  Created by Fernando Fernandes on 12.02.22.
//

import Foundation

public extension String {

    /// Returns the decimal numbers of `self`.
    ///
    /// Examples:
    ///  - 43865.52: returns "2"
    ///  - 0.934: returns "3"
    ///  - 0.00003456: returns "8"
    ///  - 2: returns "0"
    func decimalCount() -> Int {
        let split = self.split(separator: ".")
        guard split.count > 1 else {
            return 0
        }
        guard let decimalPartString = split.last else {
            return 0
        }
        return decimalPartString.count
    }
}
