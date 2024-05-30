//
//  SwiftTrader+MultipleOrders.swift
//
//
//  Created by Fernando Fernandes on 10.02.22.
//

import Foundation

/// Holds logic to create multiple orders at once.
public extension SwiftTrader {

    /// Creates five orders using the parameters from the given `SwiftTraderMultiLongLimitOrderInput` instance.
    func createMultipleLongLimitOrders(
        for orderInput: SwiftTraderMultiLongLimitOrderInput
    ) -> [KucoinSpotHFOrderParameters] {

        var orders = [KucoinSpotHFOrderParameters]()

        let numberOfOrders: Double = 5
        let fundPerOrder = orderInput.totalFunds / numberOfOrders
        let initialPriceDouble = Double(orderInput.initialPrice) ?? 0.0
        let decimalPlaces = decimalPlaces(for: orderInput.initialPrice)

        var prices = [Double]()
        for orderIndex in 1...Int(numberOfOrders) {
            let price: Double
            if orderIndex == 1 {
                price = (initialPriceDouble * orderInput.initialPriceIncrement) + initialPriceDouble
            } else {
                let previousPrice = prices[orderIndex - 2]
                price = (previousPrice * orderInput.priceIncrement) + previousPrice
            }
            prices.append(price)
        }

        for price in prices {
            let formattedPrice = format(price, decimalPlaces: decimalPlaces)
            let priceDouble = Double(formattedPrice) ?? 0.0
            let size = fundPerOrder / priceDouble
            let formattedSize = formatSize(size, decimalPlaces: decimalPlaces)

            let order = KucoinSpotHFOrderParameters(
                symbol: orderInput.symbol,
                type: .limit,
                size: formattedSize,
                price: formattedPrice,
                side: .buy
            )

            orders.append(order)
        }

        return orders
    }
}

// MARK: - Helper Functions

private extension SwiftTrader {

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
