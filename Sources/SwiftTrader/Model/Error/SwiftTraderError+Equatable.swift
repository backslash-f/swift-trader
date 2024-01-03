//
//  SwiftTraderError+Equatable.swift
//
//
//  Created by Fernando Fernandes on 03.01.24.
//

import Foundation

extension SwiftTraderError: Equatable {
    public static func == (lhs: SwiftTraderError, rhs: SwiftTraderError) -> Bool {
        switch (lhs, rhs) {
        case (.binanceMissingAuthentication,
              .binanceMissingAuthentication):
            return true

        case (.binanceSpotNewOrder(let lhsError),
              .binanceSpotNewOrder(let rhsError)):
            return (lhsError as NSError) == (rhsError as NSError)

        case (.binanceStatusCodeNotOK(let lhsStatusCode,
                                      let lhsLocalizedErrorMessage,
                                      let lhsCode,
                                      let lhsMessage),
              .binanceStatusCodeNotOK(let rhsStatusCode,
                                      let rhsLocalizedErrorMessage,
                                      let rhsCode,
                                      let rhsMessage)):
            return lhsStatusCode == rhsStatusCode
            && lhsLocalizedErrorMessage == rhsLocalizedErrorMessage
            && lhsCode == rhsCode
            && lhsMessage == rhsMessage

        case (.couldNotConvertToDouble(let lhsString),
              .couldNotConvertToDouble(let rhsString)):
            return lhsString == rhsString

        case (.invalidLastDigit,
              .invalidLastDigit):
            return true

        case (.invalidOffset(let lhsOffset, let lhsProfitPercentage),
              .invalidOffset(let rhsOffset, let rhsProfitPercentage)):
            return lhsOffset == rhsOffset && lhsProfitPercentage == rhsProfitPercentage

        case (.kucoinFuturesAccountOverview(let lhsError),
              .kucoinFuturesAccountOverview(let rhsError)):
            return (lhsError as NSError) == (rhsError as NSError)

        case (.kucoinFuturesCancelStopOrders(let lhsError),
              .kucoinFuturesCancelStopOrders(let rhsError)):
            return (lhsError as NSError) == (rhsError as NSError)

        case (.kucoinFuturesOrderList(let lhsError),
              .kucoinFuturesOrderList(let rhsError)):
            return (lhsError as NSError) == (rhsError as NSError)

        case (.kucoinFuturesPlaceStopLimitOrder(let lhsError),
              .kucoinFuturesPlaceStopLimitOrder(let rhsError)):
            return (lhsError as NSError) == (rhsError as NSError)

        case (.kucoinFuturesPositionList(let lhsError),
              .kucoinFuturesPositionList(let rhsError)):
            return (lhsError as NSError) == (rhsError as NSError)

        case (.kucoinFuturesStopOrderList(let lhsError),
              .kucoinFuturesStopOrderList(let rhsError)):
            return (lhsError as NSError) == (rhsError as NSError)

        case (.kucoinMissingAuthentication,
              .kucoinMissingAuthentication):
            return true

        case (.kucoinSpotCancelStopOrders(let lhsError),
              .kucoinSpotCancelStopOrders(let rhsError)):
            return (lhsError as NSError) == (rhsError as NSError)

        case (.kucoinSpotGetAccount(let lhsError),
              .kucoinSpotGetAccount(let rhsError)):
            return (lhsError as NSError) == (rhsError as NSError)

        case (.kucoinSpotGetTransferable(let lhsError),
              .kucoinSpotGetTransferable(let rhsError)):
            return (lhsError as NSError) == (rhsError as NSError)

        case (.kucoinSpotListAccounts(let lhsError),
              .kucoinSpotListAccounts(let rhsError)):
            return (lhsError as NSError) == (rhsError as NSError)

        case (.kucoinSpotOrderList(let lhsError),
              .kucoinSpotOrderList(let rhsError)):
            return (lhsError as NSError) == (rhsError as NSError)

        case (.kucoinSpotPlaceStopLimitOrder(let lhsError),
              .kucoinSpotPlaceStopLimitOrder(let rhsError)):
            return (lhsError as NSError) == (rhsError as NSError)

        case (.kucoinSpotStopOrderList(let lhsError),
              .kucoinSpotStopOrderList(let rhsError)):
            return (lhsError as NSError) == (rhsError as NSError)

        case (.kucoinStatusCodeNotOK(let lhsStatusCode,
                                     let lhsLocalizedErrorMessage,
                                     let lhsErrorCode,
                                     let lhsErrorMessage),
              .kucoinStatusCodeNotOK(let rhsStatusCode,
                                     let rhsLocalizedErrorMessage,
                                     let rhsErrorCode,
                                     let rhsErrorMessage)):
            return lhsStatusCode == rhsStatusCode
            && lhsLocalizedErrorMessage == rhsLocalizedErrorMessage
            && lhsErrorCode == rhsErrorCode
            && lhsErrorMessage == rhsErrorMessage

        case (.limitPriceTooHigh(let lhsEntryPrice, let lhsLimitPrice),
              .limitPriceTooHigh(let rhsEntryPrice, let rhsLimitPrice)):
            return lhsEntryPrice == rhsEntryPrice && lhsLimitPrice == rhsLimitPrice

        case (.limitPriceTooLow(let lhsEntryPrice, let lhsLimitPrice),
              .limitPriceTooLow(let rhsEntryPrice, let rhsLimitPrice)):
            return lhsEntryPrice == rhsEntryPrice && lhsLimitPrice == rhsLimitPrice

        case (.unexpected(let lhsError),
              .unexpected(let rhsError)):
            return (lhsError as NSError) == (rhsError as NSError)

        case (.unexpectedResponse(let lhsModelString),
              .unexpectedResponse(let rhsModelString)):
            return lhsModelString == rhsModelString

        default:
            return false
        }
    }
}

