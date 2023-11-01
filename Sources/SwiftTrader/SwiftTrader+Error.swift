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
            return SwiftTraderError.error(for: operation, statusCode: statusCode, localizedErrorMessage: errorMessage, data: data)
        default:
            switch operation {
            case .binanceSpotNewOrder:
                return .binanceSpotNewOrder(error: networkRequestError)
            case .kucoinSpotListAccounts:
                return .kucoinSpotListAccounts(error: networkRequestError)
            case .kucoinSpotGetAccount:
                return .kucoinSpotGetAccount(error: networkRequestError)
            case .kucoinSpotPlaceStopLimitOrder:
                return .kucoinSpotPlaceStopLimitOrder(error: networkRequestError)
            case .kucoinSpotGetTransferable:
                return .kucoinSpotGetTransferable(error: networkRequestError)
            case .kucoinSpotOrderList:
                return .kucoinSpotOrderList(error: networkRequestError)
            case .kucoinSpotStopOrderList:
                return .kucoinFuturesPositionList(error: networkRequestError)
            case .kucoinSpotCancelStopOrders:
                return .kucoinSpotCancelStopOrders(error: networkRequestError)
            case .kucoinFuturesAccountOverview:
                return .kucoinFuturesAccountOverview(error: networkRequestError)
            case .kucoinFuturesCancelStopOrders:
                return .kucoinFuturesCancelStopOrders(error: networkRequestError)
            case .kucoinFuturesStopOrderList:
                return .kucoinFuturesStopOrderList(error: networkRequestError)
            case .kucoinFuturesOrderList:
                return .kucoinFuturesOrderList(error: networkRequestError)
            case .kucoinFuturesPlaceStopLimitOrder:
                return .kucoinFuturesPlaceStopLimitOrder(error: networkRequestError)
            case .kucoinFuturesPositionList:
                return .kucoinFuturesPositionList(error: networkRequestError)
            }
        }
    }
}
