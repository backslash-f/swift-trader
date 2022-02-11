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
        let targetPercentage: Double = (input.profitPercentage / 100) - (input.offset / 100)
        let priceIncrement: Double = input.entryPrice * targetPercentage
        
        #warning("TODO: round up?")
        // Why Int? From a Kucoin response: "The parameter shall be a multiple of 1."
        let targetPrice = Int(input.entryPrice + priceIncrement)
        let targetPriceString = String(targetPrice)
        
        return KucoinOrderParameters(
            symbol: input.contractSymbol,
            side: .sell,
            type: .limit,
            stop: .down,
            stopPriceType: .TP,
            stopPrice: targetPriceString,
            price: targetPriceString,
            reduceOnly: true,
            closeOrder: true
        )
    }
}

