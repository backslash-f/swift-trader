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
            
        case .ftxPositions:
            return .ftxStatusCodeNotOK(statusCode: statusCode, localizedErrorMessage: localizedErrorMessage)
            
        case .kucoinFuturesAccountOverview,
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
                kucoinErrorCode: kucoinError.code,
                kucoinErrorMessage: kucoinError.message
            )
        }
    }
}
