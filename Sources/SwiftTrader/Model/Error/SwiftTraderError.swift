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

    // MARK: Limit/Stop Price Calculation

    /// Something went wrong while trying to convert the given `String` to `Double`.
    case couldNotConvertToDouble(string: String)

    /// Couldn't extract either price or ticket last digits.
    case invalidLastDigit

    /// The offsett has to be lower than the percentage of the profit; the order will not be placed.
    case invalidOffset(offset: Double, profitPercentage: Double)

    /// (`long` position) The limit price is lower than the entry price; the order will not be placed.
    case limitPriceTooLow(entryPrice: String, limitPrice: String)

    /// (`short` position) The limit price is higher than the entry price; the order will not be placed.
    case limitPriceTooHigh(entryPrice: String, limitPrice: String)

    // MARK: - Binance Related

    /// No `BinanceAuth` instance was given; it will be impossible to authenticate with Binance.
    case binanceMissingAuthentication

    /// And error ocurred while executing the function `SwiftTrader.binanceSpotNewOrder`.
    case binanceSpotNewOrder(error: Error)

    /// The response status code is something other than `200`.
    case binanceStatusCodeNotOK(
        statusCode: Int,
        localizedErrorMessage: String,
        code: Int? = nil,
        message: String? = nil
    )

    // MARK: - Kucoin Related

    /// No `KucoinAuth` instance was given; it will be impossible to authenticate with Kucoin.
    case kucoinMissingAuthentication

    /// The response status code is something other than `200`.
    ///
    /// The underlying Kucoin system error may be verified by reading the returned extra arguments, if present.
    case kucoinStatusCodeNotOK(
        statusCode: Int,
        localizedErrorMessage: String,
        errorCode: String? = nil,
        errorMessage: String? = nil
    )

    // MARK: Accounts

    /// And error ocurred while executing the function `SwiftTrader.kucoinListAccounts(currencySymbol:)`.
    case kucoinSpotListAccounts(error: Error)

    /// And error ocurred while executing the function `SwiftTrader.kucoinGetAccount(accountID:)`.
    case kucoinSpotGetAccount(error: Error)

    /// And error ocurred while executing the function `SwiftTrader.kucoinGetTransferable()`.
    case kucoinSpotGetTransferable(error: Error)

    // MARK: Account Overview

    /// And error ocurred while executing the function `SwiftTrader.kucoinFuturesAccountOverview(currencySymbol:)`.
    case kucoinFuturesAccountOverview(error: Error)

    // MARK: Cancel Stop Orders

    /// And error ocurred while executing the function `SwiftTrader.kucoinFuturesCancelStopOrders(symbol:)`.
    case kucoinFuturesCancelStopOrders(error: Error)

    /// And error ocurred while executing the function `SwiftTrader.kucoinSpotCancelStopOrders(symbol:)`.
    case kucoinSpotCancelStopOrders(error: Error)

    // MARK: Orders

    /// And error ocurred while executing the function `SwiftTrader.kucoinFuturesOrderList(orderStatus:)`.
    case kucoinFuturesOrderList(error: Error)

    /// And error ocurred while executing the function `SwiftTrader.kucoinSpotOrderList(orderStatus:)`.
    case kucoinSpotOrderList(error: Error)

    /// And error ocurred while executing the function `SwiftTrader.kucoinSpotStopOrderList()`.
    case kucoinSpotStopOrderList(error: Error)

    /// And error ocurred while executing the function `SwiftTrader.kucoinFuturesStopOrderList(symbol:)`.
    case kucoinFuturesStopOrderList(error: Error)

    /// And error ocurred while executing the function `SwiftTrader.kucoinFuturesPlaceStopLimitOrder()`.
    case kucoinFuturesPlaceStopLimitOrder(error: Error)

    /// And error ocurred while executing the function `SwiftTrader.SwiftTrader.kucoinSpotPlaceStopLimitOrder(_:)`.
    case kucoinSpotPlaceStopLimitOrder(error: Error)

    // MARK: Positions

    /// And error ocurred while executing the function `SwiftTrader.kucoinFuturesPositionList()`.
    case kucoinFuturesPositionList(error: Error)
}

// MARK: - Equatable

extension SwiftTraderError: Equatable {
    public static func == (lhs: SwiftTraderError, rhs: SwiftTraderError) -> Bool {
        lhs.localizedDescription == rhs.localizedDescription
    }
}
