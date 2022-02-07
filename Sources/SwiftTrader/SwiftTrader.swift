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
    
    private let settings: SwiftTraderSettings
    
    // MARK: Private
    
    private let kucoinAuth: KucoinAuth
    
    // MARK: - Lifecycle
    
    public init(kucoinAuth: KucoinAuth, settings: SwiftTraderSettings = DefaultSwiftTraderSettings()) {
        self.kucoinAuth = kucoinAuth
        self.settings = settings
    }
}

// MARK: - Interface

public extension SwiftTrader {
    
    // MARK: Account Overview
    
    func kucoinFuturesAccountOverview(currencySymbol: CurrencySymbol = .USDT) async throws -> Result<KucoinFuturesAccountOverview, SwiftTraderError> {
        let request = KucoinFuturesAccountOverviewRequest(
            currencySymbol: currencySymbol,
            kucoinAuth: kucoinAuth,
            settings: settings.networkRequestSettings
        )
        switch await request.execute() {
        case .success(let model):
            guard let accountOverview = model as? KucoinFuturesAccountOverview else {
                return .failure(.unexpectedResponse(modelString: "\(model)"))
            }
            return .success(accountOverview)
        case .failure(let error):
            let swiftTraderError = handle(networkRequestError: error, operation: .kucoinFuturesAccountOverview)
            return .failure(swiftTraderError)
        }
    }
    
    // MARK: Order List
    
    func kucoinFuturesOrderList(orderStatus: KucoinOrderStatus = .active) async throws -> Result<KucoinFuturesOrderList, SwiftTraderError> {
        let request = KucoinFuturesOrdersListRequest(
            orderStatus: orderStatus,
            kucoinAuth: kucoinAuth,
            settings: settings.networkRequestSettings
        )
        switch await request.execute() {
        case .success(let model):
            guard let orderList = model as? KucoinFuturesOrderList else {
                return .failure(.unexpectedResponse(modelString: "\(model)"))
            }
            return .success(orderList)
        case .failure(let error):
            let swiftTraderError = handle(networkRequestError: error, operation: .kucoinFuturesOrderList)
            return .failure(swiftTraderError)
        }
    }
    
    // MARK: Place Order
    
    func kucoinFuturesPlaceOrder() async throws -> Result<KucoinFuturesPlaceOrder, SwiftTraderError> {
        let request = KucoinFuturesPlaceOrdersRequest(
            kucoinAuth: kucoinAuth,
            settings: settings.networkRequestSettings
        )
        switch await request.execute() {
        case .success(let model):
            guard let placeOrder = model as? KucoinFuturesPlaceOrder else {
                return .failure(.unexpectedResponse(modelString: "\(model)"))
            }
            return .success(placeOrder)
        case .failure(let error):
            let swiftTraderError = handle(networkRequestError: error, operation: .kucoinFuturesPlaceOrder)
            return .failure(swiftTraderError)
        }
    }
    
    // MARK: Positions
    
    func kucoinFuturesPositionList() async throws -> Result<KucoinFuturesPositionList, SwiftTraderError> {
        let request = KucoinFuturesPositionListRequest(
            kucoinAuth: kucoinAuth,
            settings: settings.networkRequestSettings
        )
        switch await request.execute() {
        case .success(let model):
            guard let positionList = model as? KucoinFuturesPositionList else {
                return .failure(.unexpectedResponse(modelString: "\(model)"))
            }
            return .success(positionList)
        case .failure(let error):
            let swiftTraderError = handle(networkRequestError: error, operation: .kucoinFuturesPositionList)
            return .failure(swiftTraderError)
        }
    }
}

// MARK: - Private

private extension SwiftTrader {
    
    /// Translates a `NetworkRequestError` to a `SwiftTraderError`.
    func handle(networkRequestError: NetworkRequestError, operation: SwiftTraderOperation) -> SwiftTraderError {
        switch networkRequestError {
        case .statusCodeNotOK(let statusCode, let errorMessage, let data):
            let error = SwiftTraderError.error(for: statusCode, localizedErrorMessage: errorMessage, data: data)
            return error
        default:
            switch operation {
            case .kucoinFuturesAccountOverview:
                return .kucoinFuturesAccountOverviewError(error: networkRequestError)
            case .kucoinFuturesOrderList:
                return .kucoinOrderListError(error: networkRequestError)
            case .kucoinFuturesPlaceOrder:
                return .kucoinPlaceOrderError(error: networkRequestError)
            case .kucoinFuturesPositionList:
                return .kucoinPositionListError(error: networkRequestError)
            }
        }
    }
}
