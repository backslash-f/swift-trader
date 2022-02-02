//
//  SwiftTrader.swift
//
//
//  Created by Fernando Fernandes on 24.01.22.
//

import Foundation

/// Entry point for connecting and trading on crypto exchanges such as Binance and Kucoin.
public struct SwiftTrader {
    
    // MARK: - Properties
    
    public let kucoinAuth: KucoinAuth
    
    // MARK: - Lifecycle
    
    public init(kucoinAuth: KucoinAuth) {
        self.kucoinAuth = kucoinAuth
    }
}

// MARK: - Interface

public extension SwiftTrader {
    
    func kucoinFuturesAccountOverview() async throws -> Result<KucoinFuturesAccountOverviewResponse, SwiftTraderError> {
        let request = KucoinAccountOverviewRequest(kucoinAuth: kucoinAuth)
        switch await request.execute() {
        case .success(let model):
            guard let accountOverview = model as? KucoinFuturesAccountOverviewResponse else {
                return .failure(.unexpectedResponse(modelString: "\(model)"))
            }
            return .success(accountOverview)
        case .failure(let error):
            switch error {
            case .statusCodeNotOK(let statusCode, let errorMessage, let data):
                let error = SwiftTraderError.error(for: statusCode, localizedErrorMessage: errorMessage, data: data)
                return .failure(error)
            default:
                return .failure(.kucoinFuturesAccountOverviewError(error: error))
            }
        }
    }
}
