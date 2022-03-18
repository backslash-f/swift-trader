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
    /// - Parameter input: `SwiftTraderStopLimitOrderInput` containing required info such as `profitPercentage` and `offset`.
    /// - Returns: `StopLimitPriceTuple`, which contains the calculated stop (trigger) price and limit price.
    /// The stop price and the limit price are also tuples. These tuples provide the price in both `String` and `Double` format.
    func calculateStopLimitPrice(for input: SwiftTraderStopLimitOrderInput) throws -> StopLimitPriceTuple {
        logger.log("Exchange: \(input.exchange.rawValue.uppercased())")
        logger.log("Contract: \(input.contractSymbol)")
        
        logger.log("Calculating stop and limit prices...")
        logger.log("Side: \(input.isLong ? "LONG": "SHORT")")
        
        // E.g: 7.47 -> 0.0747
        let profitPercentage: Double = (input.profitPercentage / 100)
        logger.log("Profit percentage: \(profitPercentage.toDecimalString())")
        
        // E.g.: 0.75 -> 0.0075
        let offset: Double = (input.offset / 100)
        logger.log("Offset: \(offset.toDecimalString())")
        
        guard offset < profitPercentage else {
            throw SwiftTraderError.invalidOffset(offset: input.offset, profitPercentage: input.profitPercentage)
        }
        
        // E.g.: (0.0747 - 0.0075) = 0.0672 (6,72%)
        // Use "abs" to filter out negative numbers.
        let targetPercentage: Double = profitPercentage - offset
        logger.log("Target percentage: \(targetPercentage.toDecimalString())")
        
        // E.g.: 42000.69 * 0.0674 = 2830.846506
        let priceIncrement: Double = input.entryPrice * targetPercentage
        logger.log("Price increment: \(priceIncrement.toDecimalString())")
        logger.log("Ticker size: \(input.tickerSize)")
        logger.log("Entry price string: \(input.entryPrice.toDecimalString())")
        
        // "Long" example: 42000.69 + 2830.846506 = 44831.536506
        // "Short" example: 42000.69 - 2830.846506 = 39169.843494
        let limitPrice: Double = input.isLong ?
        input.entryPrice + priceIncrement :
        input.entryPrice - priceIncrement
        
        var limitPriceString = "\(limitPrice.toDecimalString())"
        try format(priceString: &limitPriceString, input: input)
        
        let limitPriceDouble = Double(limitPriceString) ?? 0
        
        if input.isLong {
            guard limitPriceDouble > input.entryPrice else {
                // Long position: throw in case the limit price became LOWER than the entry price
                // for whatever reason. Do not place an order in this scenario.
                throw SwiftTraderError.limitPriceTooLow(
                    entryPrice: input.entryPrice.toDecimalString(),
                    limitPrice: limitPriceString
                )
            }
        } else {
            guard limitPriceDouble < input.entryPrice else {
                // Short position: throw in case the limit price became HIGHER than the entry price
                // for whatever reason. Do not place an order in this scenario.
                throw SwiftTraderError.limitPriceTooHigh(
                    entryPrice: input.entryPrice.toDecimalString(),
                    limitPrice: limitPriceString
                )
            }
        }
        let limitPriceTuple = (limitPriceString, limitPriceDouble)
        
        logger.log("Limit price string: \(limitPriceString)")
        logger.log("Limit price double: \(limitPriceDouble)")
        
        // Stop price logic. It aims to give the order some room to be filled.
        //
        // For long positions: the stop price has to be greater than the limit price:
        // - Stop price: 127.59     <- the price is falling to this level
        // - Limit price: 127.49    <- sell when the price reaches this level
        //
        // For short positions: the stop price has to be lower than the limit price:
        // - Stop price: 127.39     <- the price is raising to this level
        // - Limit price: 127.49    <- sell when the price reaches this level
        //
        // The increment is the result of the ticker size multiplied by 10, e.g.: 0.1 * 10 = 10
        guard let tickerSizeDouble = Double(input.tickerSize) else {
            throw SwiftTraderError.couldNotConvertToDouble(string: input.tickerSize)
        }
        let stopPriceIncrement: Double = (tickerSizeDouble * 10)
        
        let stopPrice = input.isLong ?
        limitPriceDouble + stopPriceIncrement :
        limitPriceDouble - stopPriceIncrement
        
        var stopPriceString = stopPrice.toDecimalString()
        try format(priceString: &stopPriceString, input: input)
        
        guard let stopPriceDouble = Double(stopPriceString) else {
            throw SwiftTraderError.couldNotConvertToDouble(string: stopPriceString)
        }
        
        let stopPriceTuple = (stopPriceString, stopPriceDouble)
        
        logger.log("Stop price string: \(stopPriceString)")
        logger.log("Stop price double: \(stopPriceDouble)")
        
        return (stopPriceTuple, limitPriceTuple)
    }
}

private extension SwiftTrader {
    
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
            
            if ((priceDecimalDigits == 0) || (priceDecimalDigits == tickerDigits)),
               priceLastDigit != tickerLastDigit {
                priceString = priceString.dropLast() + "\(tickerLastDigit)"
                
            } else if priceDecimalDigits > tickerDigits {
                let digitsToRemove = (priceDecimalDigits - tickerDigits) + 1
                priceString = priceString.dropLast(digitsToRemove) + "\(tickerLastDigit)"
                
            } else if priceDecimalDigits < tickerDigits,
                      priceLastDigit != tickerLastDigit {
                let digitsToAdd = (tickerDigits - priceDecimalDigits)
                let digits: [String] = Array(repeating: "0", count: digitsToAdd)
                priceString = priceString + digits.joined(separator: "")
                priceString = priceString.dropLast() + "\(tickerLastDigit)"
            }
        }
    }
}
