//
//  SwiftTrader+Offset.swift
//  
//
//  Created by Fernando Fernandes on 10.02.22.
//

import Foundation

/// Creates a set of predefined parameters for interacting with target exchanges, based on a given offset.
///
/// For example: before executing a `KucoinFuturesPlaceOrdersRequest`, this extension will create
/// a `KucoinOrderParameters` instance that can be used as an argument. The business logic for creating
/// such instance is based on a given `SwiftTraderOrderInput`/`offset`.
public extension SwiftTrader {
    
    func createOrderParameters(for input: SwiftTraderOrderInput) -> KucoinOrderParameters {
        logger.log("Creating order parameters...")
        
        // E.g: 7.47 -> 0.0747
        let profitPercentage: Double = (input.profitPercentage / 100)
        logger.log("Profit percentage: \(profitPercentage.toDecimalString())")
        
        // Instead of creating an order with a fixed target percentage (say 0.025), add some fat to it (e.g.: 0.027)
        let offsetMargin: Double = 0.02
        logger.log("Offset margin: \(offsetMargin.toDecimalString())")
        
        // E.g.: (0.75 - 0.02) / 100 = 0.0073, which translates to 0.0027 (0,27%)
        let offset: Double = (input.offset - offsetMargin) / 100
        logger.log("Offset: \(offset.toDecimalString())")
        
        // E.g.: (0.0747 - 0.0073) = 0.0674 (6,74%)
        let targetPercentage: Double = profitPercentage - offset
        logger.log("Target percentage: \(targetPercentage.toDecimalString())")
        
        // E.g.: 42000.69 * 0.0674 = 2830.846506
        let priceIncrement: Double = input.entryPrice * targetPercentage
        logger.log("Price increment: \(priceIncrement.toDecimalString())")
        
        // E.g.: 42000.9 + 2830.846506 = 44831.536506
        let targetPrice: Double = input.entryPrice + priceIncrement
        logger.log("Entry price: \(input.entryPrice.toDecimalString())")
        logger.log("Target price: \(targetPrice.toDecimalString())")
        
        // Now in order to avoid a huge difference between the entry price and the target price in terms of size,
        // "normalize" them based on the entry price by first counting its characters.
        let entryPriceCount = input.entryPrice.toDecimalString().count
        logger.log("Entry price count: \(entryPriceCount)")
        
        // Count the target price characters too.
        let targetPriceCount = targetPrice.toDecimalString().count
        logger.log("Target price count: \(targetPriceCount)")
        
        // E.g.: 12 - 8 (44831.536506 - 42000.69)
        // "44831.536506" becomes "44831.53".
        let charactersToBeRemoved = abs(targetPriceCount - entryPriceCount)
        var targetPriceString = "\(targetPrice.toDecimalString())".dropLast(charactersToBeRemoved)
        logger.log("Target price normalize: \(targetPriceString)")
        
        // Finally, avoid the following Kucoin error with minimal effort: "The parameter shall be a multiple of ..."
        // First, just try replacing the last character by "1". E.g.: "0.00002347" becomes "0.00002341"
        if targetPriceString.components(separatedBy: ".").count > 1 {
            targetPriceString = targetPriceString.dropLast() + "1"
        } else {
            // Handles whole numbers: "3735" becomes "3735.1" (instead of "3731").
            targetPriceString += ".1"
        }
        logger.log("Target price string: \(targetPriceString)")
        
        // E.g.: "44831.53" becomes "44831".
        // Workaround to not call "https://docs.kucoin.com/futures/#get-open-contract-list" (for now).
        // "The price specified must be a multiple number of the contract tickSize, otherwise the system will report an
        // error when you place the order. The tick size is the smallest price increment in which the prices are quoted.
        if let priceDouble = Double(targetPriceString), priceDouble > 10 {
            targetPriceString = "\(priceDouble.rounded(.down).toDecimalString())"
        }
        
        return KucoinOrderParameters(
            symbol: input.contractSymbol,
            side: .sell,
            type: .limit,
            stop: .down,
            stopPriceType: .TP,
            stopPrice: "\(targetPriceString)",
            price: "\(targetPriceString)",
            reduceOnly: true,
            closeOrder: true
        )
    }
}

