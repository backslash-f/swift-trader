//
//  SwiftTraderError+Details.swift
//  
//
//  Created by Fernando Fernandes on 30.01.22.
//

import Foundation

/// Holds logic to return meaningful error messages containing detailed system errors whenever possible.
public extension SwiftTraderError {
    
    static func error(for operation: SwiftTraderOperation, statusCode: Int, localizedErrorMessage: String, data: Data) -> SwiftTraderError {
        switch operation {
        case .ftxCancelAllOrders,
                .ftxPlaceStopLimitOrder,
                .ftxPositions,
                .ftxTriggerOrdersList:
            guard let ftxError = try? JSONDecoder().decode(FTXError.self, from: data) else {
                return .ftxStatusCodeNotOK(statusCode: statusCode, localizedErrorMessage: localizedErrorMessage)
            }
            return .ftxStatusCodeNotOK(
                statusCode: statusCode,
                localizedErrorMessage: localizedErrorMessage,
                isSuccess: ftxError.isSuccess,
                errorMessage: ftxError.errorMessage
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
                .kucoinFuturesPositionList:
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
