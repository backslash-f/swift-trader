//
//  SwiftTraderError.swift
//  
//
//  Created by Fernando Fernandes on 30.01.22.
//

import Foundation

/// Encapsulates errors that may happen during `SwiftTrader` operations.
public enum SwiftTraderError: Error {
    
    // MARK: - Generic
    
    /// An unexpected error happened.
    case unexpected(_ error: Error)
    
    /// The returned model is unexpected.
    case unexpectedResponse(modelString: String)
    
    // MARK: - Kucoin Related
    
    /// No `KucoinAuth` instance was given; it will be impossible to authenticate with Kucoin.
    case kucoinMissingAuthentication
    
    /// The response status code is something other than `200`.
    ///
    /// The underlying Kucoin system error may be verified by reading the returned extra arguments, if present.
    case kucoinStatusCodeNotOK(
        statusCode: Int,
        localizedErrorMessage: String,
        kucoinErrorCode: String? = nil,
        kucoinErrorMessage: String? = nil
    )
    
    // MARK: Account Overview
    
    /// And error ocurred while executing the function `SwiftTrader.kucoinFuturesAccountOverview(currencySymbol:)`.
    case kucoinFuturesAccountOverview(error: Error)
    
    // MARK: Cancel Stop Orders
    
    /// And error ocurred while executing the function `SwiftTrader.kucoinFuturesCancelStopOrders(symbol:)`.
    case kucoinFuturesCancelStopOrders(error: Error)
    
    // MARK: Orders
    
    /// Something went wrong while trying to set the target price.
    case kucoinCouldNotCalculateTheTargetPrice(input: SwiftTraderStopLimitOrderInput)
    
    /// The offsett has to be lower than the percentage of the profit; the order will not be placed.
    case kucoinInvalidOffset(offset: Double, profitPercentage: Double)
    
    /// (`long` position) The target price is lower than the entry price; the order will not be placed.
    case kucoinInvalidTargetPriceLower(entryPrice: String, targetPrice: String)
    
    /// (`short` position) The target price is higher than the entry price; the order will not be placed.
    case kucoinInvalidTargetPriceHigher(entryPrice: String, targetPrice: String)
    
    /// And error ocurred while executing the function `SwiftTrader.kucoinFuturesOrderList(orderStatus:)`.
    case kucoinFuturesOrderList(error: Error)
    
    /// And error ocurred while executing the function `SwiftTrader.kucoinFuturesStopOrderList(symbol:)`.
    case kucoinFuturesStopOrderList(error: Error)
    
    /// And error ocurred while executing the function `SwiftTrader.kucoinFuturesPlaceStopLimitOrder()`.
    case kucoinFuturesPlaceStopLimitOrder(error: Error)
    
    // MARK: Positions
    
    /// And error ocurred while executing the function `SwiftTrader.kucoinFuturesPositionList()`.
    case kucoinFuturesPositionList(error: Error)
}
