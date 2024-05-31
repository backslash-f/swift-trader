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

        var formattedPrices = Set<String>()
        var previousPrice = initialPriceDouble

        for orderIndex in 1...Int(numberOfOrders) {
            var price: Double
            if orderIndex == 1 {
                price = (initialPriceDouble * orderInput.initialPriceIncrement) + initialPriceDouble
            } else {
                price = (previousPrice * orderInput.priceIncrement) + previousPrice
            }

            var formattedPrice = format(price, decimalPlaces: decimalPlaces)

            // Ensure unique formatted prices. For example, eliminate prices like
            // "0.059, 0.059"; instead, transform them into "0.059, 0.060", etc,
            // -- avoiding duplicated orders.
            while formattedPrices.contains(formattedPrice) {
                price += pow(10, -Double(decimalPlaces))
                formattedPrice = format(price, decimalPlaces: decimalPlaces)
            }

            formattedPrices.insert(formattedPrice)
            previousPrice = price

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
