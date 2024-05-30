//
//  SwiftTrader+MultipleShortLimitOrders.swift
//
//
//  Created by Fernando Fernandes on 30.05.24.
//

import Foundation

/// Holds logic to create multiple short orders at once.
public extension SwiftTrader {

    /// Creates five orders using the parameters from the given `SwiftTraderMultiShortLimitOrderInput` instance.
    func createMultipleShortLimitOrders(
        for orderInput: SwiftTraderMultiShortLimitOrderInput
    ) -> [KucoinSpotHFOrderParameters] {

        var orders = [KucoinSpotHFOrderParameters]()

        let numberOfOrders: Double = 5
        let initialPriceDouble = Double(orderInput.initialPrice) ?? 0.0
        let decimalPlaces = decimalPlaces(for: orderInput.initialPrice)

        var prices = [Double]()
        for orderIndex in 1...Int(numberOfOrders) {
            let price: Double
            if orderIndex == 1 {
                price = (initialPriceDouble * orderInput.targetProfitPercentage) + initialPriceDouble
            } else {
                let previousPrice = prices[orderIndex - 2]
                price = previousPrice - (previousPrice * orderInput.priceDecrement)
            }
            prices.append(price)
        }

        for price in prices {
            let formattedPrice = format(price, decimalPlaces: decimalPlaces)
            let formattedSize = formatSize(orderInput.totalSize, decimalPlaces: decimalPlaces)

            let order = KucoinSpotHFOrderParameters(
                symbol: orderInput.symbol,
                type: .limit,
                size: formattedSize,
                price: formattedPrice,
                side: .sell
            )

            orders.append(order)
        }

        return orders
    }
}
