//
//  SwiftTrader+MultipleOrders.swift
//
//
//  Created by Fernando Fernandes on 10.02.22.
//

import Foundation

/// Holds logic to create multiple orders at once.

public extension SwiftTrader {

    /// Creates 5 buy/limit orders using the parameters from the given `SwiftTraderMultiLimitOrderInput` instance.
    func createMultipleLongLimitOrders(
        for orderInput: SwiftTraderMultiLimitOrderInput
    ) -> [KucoinSpotHFOrderParameters] {

        var orders = [KucoinSpotHFOrderParameters]()

        let numberOfOrders: Double = 5
        let fundPerOrder = orderInput.totalFunds / numberOfOrders
        let maxBidDouble = Double(orderInput.maxBid) ?? 0.0
        let decimalPlaces = decimalPlaces(for: orderInput.maxBid)

        for orderIndex in 1...Int(numberOfOrders) {
            let price = calculatePrice(maxBid: maxBidDouble,
                                       initialPriceIncrement: orderInput.initialPriceIncrement,
                                       priceIncrement: orderInput.priceIncrement,
                                       orderIndex: orderIndex)
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

    /// Helper function to calculate the price for each order.
    func calculatePrice(maxBid: Double,
                        initialPriceIncrement: Double,
                        priceIncrement: Double,
                        orderIndex: Int) -> Double {
        if orderIndex == 1 {
            return (maxBid * initialPriceIncrement) + maxBid
        } else {
            let previousPrice = calculatePrice(
                maxBid: maxBid,
                initialPriceIncrement: initialPriceIncrement,
                priceIncrement: priceIncrement,
                orderIndex: orderIndex - 1
            )
            return previousPrice * (1 + priceIncrement)
        }
    }
}
