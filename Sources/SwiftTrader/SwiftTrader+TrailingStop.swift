//
//  SwiftTrader+TrailingStop.swift
//  
//
//  Created by Fernando Fernandes on 10.02.22.
//

import Foundation

/// Holds logic to calculate a trailing stop price.
public extension SwiftTrader {
    
    typealias TargetPriceTuple = (priceString: String, priceDouble: Double)
    
    /// Calculates a trailing stop price according to the parameters of the given `SwiftTraderStopLimitOrderInput`,
    /// such as the `profitPercentage`, `offset`, etc.
    ///
    /// - Parameter input: `SwiftTraderStopLimitOrderInput`
    /// - Returns: `TargetPriceTuple`, which contains the calculated price in both `String` and `Double` format.
    func calculateTargetPrice(for input: SwiftTraderStopLimitOrderInput) throws -> TargetPriceTuple {
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
        let targetPrice: Double = input.isLong ?
        input.entryPrice + priceIncrement :
        input.entryPrice - priceIncrement
        
        logger.log("Entry price: \(input.entryPrice.toDecimalString())")
        logger.log("Target price: \(targetPrice.toDecimalString())")
        
        var targetPriceString = "\(targetPrice.toDecimalString())"
        
        // Finally, handle the following requirement:
        //
        // "The price specified must be a multiple number of the contract tickSize, otherwise the system will report an
        // error when you place the order. The tick size is the smallest price increment in which the prices are quoted.
        guard let tickerSizeDouble = Double(input.tickerSize),
              let priceDouble = Double(targetPriceString) else {
                  throw SwiftTraderError.couldNotCalculateTargetPrice(input: input)
              }
        
        // Whole ticker size like "1", "2", etc.
        if tickerSizeDouble.truncatingRemainder(dividingBy: 1) == 0 {
            // E.g.: "44831.53" becomes "44832".
            targetPriceString = "\(priceDouble.rounded(.up).toDecimalString())"
            
        } else {
            // Handle ticker sizes like "0.0001", "0.05", "0.00000001", etc.
            //
            // E.g., considering "0.0001":
            // - "0.023" becomes "0.0231"
            // - "0.0456" becomes "0.0451"
            // - "0.7" becomes "0.7001"
            guard let targetPriceLastDigit = targetPriceString.last,
                  let tickerLastDigit = input.tickerSize.last else {
                      throw SwiftTraderError.couldNotCalculateTargetPrice(input: input)
                  }
            
            let tickerDigits = input.tickerSize.decimalCount()
            let targetPriceDigits = targetPriceString.decimalCount()
            
            if targetPriceDigits == tickerDigits, targetPriceLastDigit != tickerLastDigit {
                targetPriceString = targetPriceString.dropLast() + "\(tickerLastDigit)"
                
            } else if targetPriceDigits > tickerDigits {
                let digitsToRemove = (targetPriceDigits - tickerDigits) + 1
                targetPriceString = targetPriceString.dropLast(digitsToRemove) + "\(tickerLastDigit)"
                
            } else if targetPriceDigits < tickerDigits {
                let digitsToAdd = (tickerDigits - targetPriceDigits)
                let digits: [String] = Array(repeating: "0", count: digitsToAdd)
                targetPriceString = targetPriceString + digits.joined(separator: "")
                targetPriceString = targetPriceString.dropLast() + "\(tickerLastDigit)"
            }
        }
        
        logger.log("Ticker size: \(input.tickerSize)")
        logger.log("Target price string: \(targetPriceString)")
        
        let targetPriceDouble = Double(targetPriceString) ?? 0
        
        if input.isLong {
            guard targetPriceDouble > input.entryPrice else {
                // Long position: throw in case the target price became LOWER than the entry price
                // for whatever reason. Do not place an order in this scenario.
                throw SwiftTraderError.invalidTargetPriceTooLow(
                    entryPrice: input.entryPrice.toDecimalString(),
                    targetPrice: targetPriceString
                )
            }
        } else {
            guard targetPriceDouble < input.entryPrice else {
                // Short position: throw in case the target price became HIGHER than the entry price
                // for whatever reason. Do not place an order in this scenario.
                throw SwiftTraderError.invalidTargetPriceTooHigh(
                    entryPrice: input.entryPrice.toDecimalString(),
                    targetPrice: targetPriceString
                )
            }
        }
        return (targetPriceString, targetPriceDouble)
    }
}
