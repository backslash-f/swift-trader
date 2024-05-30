//
//  SwiftTrader+Error.swift
//
//
//  Created by Fernando Fernandes on 07.03.22.
//

import Foundation

public extension SwiftTrader {

    /// Translates a `NetworkRequestError` to a `SwiftTraderError`.
    func handle(networkRequestError: NetworkRequestError, operation: SwiftTraderOperation) -> SwiftTraderError {
        switch networkRequestError {
        case .statusCodeNotOK(let statusCode, let errorMessage, let data):
            return SwiftTraderError.error(
                for: operation,
                statusCode: statusCode,
                localizedErrorMessage: errorMessage, data: data
            )
        default:
            let operationErrorDictionary: [SwiftTraderOperation: (NetworkRequestError) -> SwiftTraderError] = [
                .binanceSpotNewOrder: SwiftTraderError.binanceSpotNewOrder,
                .kucoinSpotListAccounts: SwiftTraderError.kucoinSpotListAccounts,
                .kucoinSpotGetAccount: SwiftTraderError.kucoinSpotGetAccount,
                .kucoinSpotPlaceStopLimitOrder: SwiftTraderError.kucoinSpotPlaceStopLimitOrder,
                .kucoinSpotGetTransferable: SwiftTraderError.kucoinSpotGetTransferable,
                .kucoinSpotOrderList: SwiftTraderError.kucoinSpotOrderList,
                .kucoinSpotStopOrderList: SwiftTraderError.kucoinFuturesPositionList,
                .kucoinSpotCancelStopOrders: SwiftTraderError.kucoinSpotCancelStopOrders,
                .kucoinSpotHFPlaceMultipleOrders: SwiftTraderError.kucoinSpotHFPlaceMultipleOrders,
                .kucoinFuturesAccountOverview: SwiftTraderError.kucoinFuturesAccountOverview,
                .kucoinFuturesCancelStopOrders: SwiftTraderError.kucoinFuturesCancelStopOrders,
                .kucoinFuturesStopOrderList: SwiftTraderError.kucoinFuturesStopOrderList,
                .kucoinFuturesOrderList: SwiftTraderError.kucoinFuturesOrderList,
                .kucoinFuturesPlaceStopLimitOrder: SwiftTraderError.kucoinFuturesPlaceStopLimitOrder,
                .kucoinFuturesPositionList: SwiftTraderError.kucoinFuturesPositionList
            ]

            return operationErrorDictionary[operation]?(networkRequestError) ?? .unexpected(networkRequestError)
        }
    }
}
