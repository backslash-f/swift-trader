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
        logger.log("Creating order parameters...")
        
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
        
        // "Long" example: 42000.69 + 2830.846506 = 44831.536506
        // "Short" example: 42000.69 - 2830.846506 = 39169.843494
        let limitPrice: Double = input.isLong ?
        input.entryPrice + priceIncrement :
        input.entryPrice - priceIncrement
        
        logger.log("Entry price: \(input.entryPrice.toDecimalString())")
        logger.log("Limit price: \(limitPrice.toDecimalString())")
        
        var limitPriceString = "\(limitPrice.toDecimalString())"
        
        // Finally, handle the following requirement:
        //
        // "The price specified must be a multiple number of the contract tickSize, otherwise the system will report an
        // error when you place the order. The tick size is the smallest price increment in which the prices are quoted.
        guard let tickerSizeDouble = Double(input.tickerSize),
              let priceDouble = Double(limitPriceString) else {
                  throw SwiftTraderError.couldNotCalculateLimitPrice(input: input)
              }
        
        // Whole ticker size like "1", "2", etc.
        if tickerSizeDouble.truncatingRemainder(dividingBy: 1) == 0 {
            // E.g.: "44831.53" becomes "44832".
            limitPriceString = "\(priceDouble.rounded(.up).toDecimalString())"
            
        } else {
            // Handle ticker sizes like "0.0001", "0.05", "0.00000001", etc.
            //
            // E.g., considering "0.0001":
            // - "0.023" becomes "0.0231"
            // - "0.0456" becomes "0.0451"
            // - "0.7" becomes "0.7001"
            guard let limitPriceLastDigit = limitPriceString.last,
                  let tickerLastDigit = input.tickerSize.last else {
                      throw SwiftTraderError.couldNotCalculateLimitPrice(input: input)
                  }
            
            let tickerDigits = input.tickerSize.decimalCount()
            let limitPriceDigits = limitPriceString.decimalCount()
            
            if limitPriceDigits == tickerDigits, limitPriceLastDigit != tickerLastDigit {
                limitPriceString = limitPriceString.dropLast() + "\(tickerLastDigit)"
                
            } else if limitPriceDigits > tickerDigits {
                let digitsToRemove = (limitPriceDigits - tickerDigits) + 1
                limitPriceString = limitPriceString.dropLast(digitsToRemove) + "\(tickerLastDigit)"
                
            } else if limitPriceDigits < tickerDigits {
                let digitsToAdd = (tickerDigits - limitPriceDigits)
                let digits: [String] = Array(repeating: "0", count: digitsToAdd)
                limitPriceString = limitPriceString + digits.joined(separator: "")
                limitPriceString = limitPriceString.dropLast() + "\(tickerLastDigit)"
            }
        }
        
        logger.log("Ticker size: \(input.tickerSize)")
        logger.log("Limit price string: \(limitPriceString)")
        
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
        let stopPriceIncrement: Double = (tickerSizeDouble * 10)
        
        let stopPriceDouble = input.isLong ?
        limitPriceDouble + stopPriceIncrement :
        limitPriceDouble - stopPriceIncrement
        
        let stopPriceString = stopPriceDouble.toDecimalString()
        let stopPriceTuple = (stopPriceString, stopPriceDouble)
        
        return (stopPriceTuple, limitPriceTuple)
    }
}
