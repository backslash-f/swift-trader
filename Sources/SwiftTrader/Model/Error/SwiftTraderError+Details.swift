//
//  SwiftTraderError+Details.swift
//
//
//  Created by Fernando Fernandes on 30.01.22.
//

import Foundation

/// Holds logic to return meaningful error messages containing detailed system errors whenever possible.
public extension SwiftTraderError {

    static func error(for operation: SwiftTraderOperation,
                      statusCode: Int,
                      localizedErrorMessage: String,
                      data: Data) -> SwiftTraderError {
        switch operation {
        case .binanceSpotNewOrder:
            guard let binanceError = try? JSONDecoder().decode(BinanceError.self, from: data) else {
                return .binanceStatusCodeNotOK(statusCode: statusCode, localizedErrorMessage: localizedErrorMessage)
            }
            return .binanceStatusCodeNotOK(
                statusCode: statusCode,
                localizedErrorMessage: localizedErrorMessage,
                code: binanceError.code,
                message: binanceError.message
            )

        case .kucoinSpotListAccounts,
                .kucoinSpotGetAccount,
                .kucoinSpotGetTransferable,
                .kucoinSpotPlaceStopLimitOrder,
                .kucoinSpotOrderList,
                .kucoinSpotStopOrderList,
                .kucoinSpotCancelStopOrders,
                .kucoinFuturesAccountOverview,
                .kucoinFuturesCancelStopOrders,
                .kucoinFuturesOrderList,
                .kucoinFuturesStopOrderList,
                .kucoinFuturesPlaceStopLimitOrder,
                .kucoinFuturesPositionList,
                .kucoinSpotWebSocketPrivateToken:
            guard let kucoinError = try? JSONDecoder().decode(KucoinSystemError.self, from: data) else {
                return .kucoinStatusCodeNotOK(statusCode: statusCode, localizedErrorMessage: localizedErrorMessage)
            }
            return .kucoinStatusCodeNotOK(
                statusCode: statusCode,
                localizedErrorMessage: localizedErrorMessage,
                errorCode: kucoinError.code,
                errorMessage: kucoinError.message
            )
        }
    }
}
