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
    
    /// The returned model is unexpected.
    case unexpectedResponse(modelString: String)
    
    // MARK: - Kucoin Related
    
    /// And error ocurred while executing the function `SwiftTrader.kucoinFuturesAccountOverview(currencySymbol:)`.
    case kucoinFuturesAccountOverview(error: Error)
    
    /// And error ocurred while executing the function `SwiftTrader.kucoinFuturesCancelStopOrders(symbol:)`.
    case kucoinFuturesCancelStopOrders(error: Error)
    
    /// Something went wrong while trying to set the target price.
    case kucoinCouldNotCalculateTheTargetPrice(input: SwiftTraderOrderInput)
    
    /// The target price is lower than the entry price; the order will not be placed.
    case kucoinInvalidTargetPrice(entryPrice: String, targetPrice: String)
    
    /// And error ocurred while executing the function `SwiftTrader.kucoinFuturesPlaceOrder()`.
    case kucoinPlaceOrder(error: Error)
    
    /// And error ocurred while executing the function `SwiftTrader.kucoinFuturesOrderList(orderStatus:)`.
    case kucoinOrderList(error: Error)
    
    /// And error ocurred while executing the function `SwiftTrader.kucoinFuturesPositionList()`.
    case kucoinPositionList(error: Error)
    
    /// The response status code is something other than `200`.
    ///
    /// The underlying Kucoin system error may be verified by reading the returned extra arguments, if present.
    case statusCodeNotOK(
        statusCode: Int,
        localizedErrorMessage: String,
        kucoinErrorCode: String? = nil,
        kucoinErrorMessage: String? = nil
    )
}
