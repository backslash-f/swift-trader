//
//  SwiftTrader+TrailingStop.swift
//
//
//  Created by Fernando Fernandes on 10.02.22.
//

import Foundation

/// Holds logic to calculate a trailing stop price.
public extension SwiftTrader {

    typealias StopPriceTuple = (string: String, double: Double)
    typealias LimitPriceTuple = (string: String, double: Double)
    typealias StopLimitPriceTuple = (stop: StopPriceTuple, limit: LimitPriceTuple)

    /// Calculates the stop and limit prices for a trailing stop strategy based on the given input parameters.
    ///
    /// - Parameter input: `SwiftTraderStopLimitOrderInput` containing required info,
    /// such as `profitPercentage` and `offset`.
    /// - Returns: `StopLimitPriceTuple`, which contains the calculated stop (trigger) price and limit price.
    /// The stop price and the limit price are also tuples. These tuples provide the price in both `String`
    /// and `Double` format.
    func calculateStopLimitPrice(for input: SwiftTraderStopLimitOrderInput) throws -> StopLimitPriceTuple {
        log(input)

        let profitPercentage = calculate(profitPercentage: input.profitPercentage)
        let offset = calculate(offset: input.offset)

        try validate(offset, profitPercentage: profitPercentage, input: input)

        let targetPercentage = calculateTargetPercentage(profitPercentage: profitPercentage, offset: offset)
        let priceIncrement = calculatePriceIncrement(entryPrice: input.entryPrice, targetPercentage: targetPercentage)

        let limitPrice = calculateLimitPrice(input: input, priceIncrement: priceIncrement)
        let limitPriceTuple = try format(limitPrice: limitPrice, input: input)

        let stopPriceTuple = try calculateStopPrice(limitPriceTuple: limitPriceTuple, input: input)

        return (stopPriceTuple, limitPriceTuple)
    }
}

private extension SwiftTrader {
    func log(_ input: SwiftTraderStopLimitOrderInput) {
        logger.log("Exchange: \(input.exchange.rawValue.uppercased())")
        logger.log("Contract: \(input.contractSymbol)")
        logger.log("Calculating stop and limit prices...")
        logger.log("Side: \(input.isLong ? "LONG": "SHORT")")
        logger.log("Size: \(input.size)")
    }

    /// E.g.: 7.47 -> 0.0747
    func calculate(profitPercentage: Double) -> Double {
        let profitPercentage: Double = (profitPercentage / 100)
        logger.log("Profit percentage: \(profitPercentage.toDecimalString())")
        return profitPercentage
    }

    /// E.g.: 0.75 -> 0.0075
    func calculate(offset: Double) -> Double {
        let offset: Double = (offset / 100)
        logger.log("Offset: \(offset.toDecimalString())")
        return offset
    }

    func validate(_ offset: Double, profitPercentage: Double, input: SwiftTraderStopLimitOrderInput) throws {
        guard offset < profitPercentage else {
            throw SwiftTraderError.invalidOffset(offset: input.offset, profitPercentage: input.profitPercentage)
        }
    }

    /// E.g.: (0.0747 - 0.0075) = 0.0672 (6,72%)
    /// Use "abs" to filter out negative numbers.
    func calculateTargetPercentage(profitPercentage: Double, offset: Double) -> Double {
        let targetPercentage: Double = profitPercentage - offset
        logger.log("Target percentage: \(targetPercentage.toDecimalString())")
        return targetPercentage
    }

    /// E.g.: 42000.69 * 0.0674 = 2830.846506
    func calculatePriceIncrement(entryPrice: Double, targetPercentage: Double) -> Double {
        let priceIncrement: Double = entryPrice * targetPercentage
        logger.log("Price increment: \(priceIncrement.toDecimalString())")
        return priceIncrement
    }

    /// "Long" example: 42000.69 + 2830.846506 = 44831.536506
    /// "Short" example: 42000.69 - 2830.846506 = 39169.843494
    func calculateLimitPrice(input: SwiftTraderStopLimitOrderInput, priceIncrement: Double) -> Double {
        let limitPrice: Double = input.isLong ?
        input.entryPrice + priceIncrement :
        input.entryPrice - priceIncrement
        return limitPrice
    }

    func format(limitPrice: Double, input: SwiftTraderStopLimitOrderInput) throws -> (String, Double) {
        var limitPriceString = "\(limitPrice.toDecimalString())"
        try format(priceString: &limitPriceString, input: input)

        let limitPriceDouble = Double(limitPriceString) ?? 0
        try validateLimitPrice(limitPriceDouble: limitPriceDouble, limitPriceString: limitPriceString, input: input)

        return (limitPriceString, limitPriceDouble)
    }

    func validateLimitPrice(limitPriceDouble: Double,
                            limitPriceString: String,
                            input: SwiftTraderStopLimitOrderInput) throws {
        if input.isLong {
            guard limitPriceDouble > input.entryPrice else {
                // Long position: throw in case the limit price became LOWER than the entry price,
                // for whatever reason. Do not place an order in this scenario.
                throw SwiftTraderError.limitPriceTooLow(
                    entryPrice: input.entryPrice.toDecimalString(),
                    limitPrice: limitPriceString
                )
            }
        } else {
            guard limitPriceDouble < input.entryPrice else {
                // Short position: throw in case the limit price became HIGHER than the entry price,
                // for whatever reason. Do not place an order in this scenario.
                throw SwiftTraderError.limitPriceTooHigh(
                    entryPrice: input.entryPrice.toDecimalString(),
                    limitPrice: limitPriceString
                )
            }
        }
    }

    /// The stop price logic aims to give the order some room to be filled.
    ///
    /// For long positions: the stop price has to be greater than the limit price:
    /// - Stop price: 127.59     <- the price is falling to this level
    /// - Limit price: 127.49    <- sell when the price reaches this level
    ///
    /// For short positions: the stop price has to be lower than the limit price:
    /// - Stop price: 127.39     <- the price is raising to this level
    /// - Limit price: 127.49    <- sell when the price reaches this level
    ///
    /// The increment is the result of the ticker size multiplied by 10, e.g.: 0.1 * 10 = 10
    func calculateStopPrice(limitPriceTuple: (String, Double),
                            input: SwiftTraderStopLimitOrderInput) throws -> (String, Double) {
        guard let tickerSizeDouble = Double(input.tickerSize) else {
            throw SwiftTraderError.couldNotConvertToDouble(string: input.tickerSize)
        }

        let stopPriceIncrement: Double = (tickerSizeDouble * 10)

        let stopPrice = input.isLong ?
        limitPriceTuple.1 + stopPriceIncrement :
        limitPriceTuple.1 - stopPriceIncrement

        var stopPriceString = stopPrice.toDecimalString()
        try format(priceString: &stopPriceString, input: input)

        guard let stopPriceDouble = Double(stopPriceString) else {
            throw SwiftTraderError.couldNotConvertToDouble(string: stopPriceString)
        }

        return (stopPriceString, stopPriceDouble)
    }

    /// Handle the following requirement (e.g. Kucoin): *"The price specified must be a multiple number of the
    /// contract `tickSize`, otherwise the system will report an error when you place the order."*
    ///
    /// - Parameters:
    ///   - priceString: `String`, price to be formatted.
    ///   - input: Holds the tick size -- the smallest price increment in which the prices are quoted.
    func format(priceString: inout String, input: SwiftTraderStopLimitOrderInput) throws {

        guard let tickerSizeDouble = Double(input.tickerSize) else {
            throw SwiftTraderError.couldNotConvertToDouble(string: input.tickerSize)
        }
        guard let priceDouble = Double(priceString) else {
            throw SwiftTraderError.couldNotConvertToDouble(string: priceString)
        }

        // Whole ticker size like "1", "2", etc.
        if tickerSizeDouble.truncatingRemainder(dividingBy: 1) == 0 {
            // E.g.: "44831.53" becomes "44832".
            priceString = "\(priceDouble.rounded(.up).toDecimalString())"

        } else {
            // Handle ticker sizes like "0.0001", "0.05", "0.00000001", etc.
            //
            // E.g., considering "0.0001":
            // - "0.023" becomes "0.0231"
            // - "0.0456" becomes "0.0451"
            // - "0.7" becomes "0.7001"
            guard let priceLastDigit = priceString.last,
                  let tickerLastDigit = input.tickerSize.last else {
                throw SwiftTraderError.invalidLastDigit
            }

            let tickerDigits = input.tickerSize.decimalCount()
            let priceDecimalDigits = priceString.decimalCount()

            if priceDecimalDigits == 0 || priceDecimalDigits == tickerDigits,
               priceLastDigit != tickerLastDigit {
                priceString = priceString.dropLast() + "\(tickerLastDigit)"

            } else if priceDecimalDigits > tickerDigits {
                let digitsToRemove = (priceDecimalDigits - tickerDigits) + 1
                priceString = priceString.dropLast(digitsToRemove) + "\(tickerLastDigit)"

            } else if priceDecimalDigits < tickerDigits,
                      priceLastDigit != tickerLastDigit {
                let digitsToAdd = (tickerDigits - priceDecimalDigits)
                let digits: [String] = Array(repeating: "0", count: digitsToAdd)
                priceString += digits.joined(separator: "")
                priceString = priceString.dropLast() + "\(tickerLastDigit)"
            }
        }
    }
}
