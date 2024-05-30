//
//  SwiftTrader+MultipleLongLimitOrders.swift
//
//
//  Created by Fernando Fernandes on 10.02.22.
//

import Foundation

/// Holds logic to create multiple limit orders at once.
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
