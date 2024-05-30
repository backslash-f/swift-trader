//
//  SwiftTrader+MultiOrderHelpers.swift
//
//
//  Created by Fernando Fernandes on 30.05.24.
//

import Foundation

extension SwiftTrader {

    /// Helper function to format the given number to the required number of decimal places.
    func format(_ number: Double, decimalPlaces: Int) -> String {
        String(format: "%.\(decimalPlaces)f", number)
    }

    func formatSize(_ size: Double, decimalPlaces: Int) -> String {
        if size > 1 {
            // Round down to the nearest whole number
            let roundedSize = Int(floor(size))
            return String(roundedSize)
        } else {
            return format(size, decimalPlaces: decimalPlaces)
        }
    }

    /// Helper function to determine the number of decimal places in the given String`.
    func decimalPlaces(for value: String) -> Int {
        if let decimalRange = value.range(of: ".") {
            return value.distance(
                from: decimalRange.upperBound,
                to: value.endIndex
            )
        } else {
            return 0
        }
    }
}
