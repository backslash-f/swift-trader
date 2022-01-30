//
//  SwiftTraderError+Kucoin.swift
//  
//
//  Created by Fernando Fernandes on 30.01.22.
//

import Foundation

/// Holds logic to return meaningful error messages containing detailed Kucoin system errors whenever possible.
public extension SwiftTraderError {
    
    static func error(for statusCode: Int, localizedErrorMessage: String, data: Data) -> SwiftTraderError {
        guard let kucoinError = try? JSONDecoder().decode(KucoinSystemError.self, from: data) else {
            return .statusCodeNotOK(statusCode: statusCode, localizedErrorMessage: localizedErrorMessage)
        }
        return .statusCodeNotOK(
            statusCode: statusCode,
            localizedErrorMessage: localizedErrorMessage,
            kucoinErrorCode: kucoinError.code,
            kucoinErrorMessage: kucoinError.message
        )
    }
}
