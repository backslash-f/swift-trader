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

        var formattedPrices = Set<String>()
        var previousPrice = initialPriceDouble

        for orderIndex in 1...Int(numberOfOrders) {
            var price: Double
            if orderIndex == 1 {
                price = (initialPriceDouble * orderInput.targetProfitPercentage) + initialPriceDouble
            } else {
                price = previousPrice - (previousPrice * orderInput.priceDecrement)
            }

            var formattedPrice = format(price, decimalPlaces: decimalPlaces)

            // Ensure unique formatted prices. For example, eliminate prices like
            // "0.059, 0.059"; instead, transform them into "0.059, 0.058", etc,
            // -- avoiding duplicated orders.
            while formattedPrices.contains(formattedPrice) {
                price -= pow(10, -Double(decimalPlaces))
                formattedPrice = format(price, decimalPlaces: decimalPlaces)
            }

            formattedPrices.insert(formattedPrice)
            previousPrice = price

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
