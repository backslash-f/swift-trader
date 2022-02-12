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
        let decimalPartString = self.split(separator: ".").last
        return decimalPartString?.count ?? 0
    }
}
