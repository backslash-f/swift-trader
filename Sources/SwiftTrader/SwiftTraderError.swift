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
    case kucoinFuturesAccountOverviewError(error: Error)
    
    /// And error ocurred while executing the function `SwiftTrader.kucoinFuturesOrderList(orderStatus:)`.
    case kucoinOrderListError(error: Error)
    
    /// And error ocurred while executing the function `SwiftTrader.kucoinFuturesPositionList()`.
    case kucoinPositionListError(error: Error)
    
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
