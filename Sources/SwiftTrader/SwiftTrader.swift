//
//  SwiftTrader.swift
//
//
//  Created by Fernando Fernandes on 24.01.22.
//

import Foundation
import Logging

/// Entry point for connecting and trading on crypto exchanges such as Binance and Kucoin.
public struct SwiftTrader {
    
    // MARK: - Properties
    
    public let logger = SwiftTraderLogger()
    
    // MARK: Private
    
    private let kucoinAuth: KucoinAuth
    
    private let settings: SwiftTraderSettings
    
    // MARK: - Lifecycle
    
    public init(kucoinAuth: KucoinAuth, settings: SwiftTraderSettings = DefaultSwiftTraderSettings()) {
        self.kucoinAuth = kucoinAuth
        self.settings = settings
    }
}

// MARK: - Interface

public extension SwiftTrader {
    
    // MARK: Account Overview
    
    /// Retrieves the overview of a Kucoin Futures account.
    ///
    /// https://docs.kucoin.com/futures/#account
    ///
    /// - Parameter currencySymbol: The `CurrencySymbol` of the account balance. The default is `.USDT`.
    /// - Returns: An instance of `KucoinFuturesAccountOverview` or `SwiftTraderError`.
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
    
    // MARK: List Orders
    
    /// Retrieves the list of active Futures orders.
    ///
    /// Notice: this does **not** include the list of stop orders
    /// https://docs.kucoin.com/futures/#get-order-list
    ///
    /// - Parameter orderStatus: `KucoinFuturesOrderStatus`, default is `.active`.
    /// - Returns: An instance of `KucoinFuturesOrderList` or `SwiftTraderError`.
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
    
    // MARK: Place Orders
    
    /// Places a Futures stop limit order.
    ///
    /// https://docs.kucoin.com/futures/#place-an-order
    ///
    /// - Parameter orderInput: `SwiftTraderStopLimitOrderInput` instance that encapsulates
    /// all the arguments required for submiting the stop limit order.
    /// - Returns: An instance of `KucoinFuturesPlaceOrder` or `SwiftTraderError`.
    func kucoinFuturesPlaceStopLimitOrder(_ orderInput: SwiftTraderStopLimitOrderInput) async throws -> Result<KucoinFuturesPlaceOrder, SwiftTraderError> {
        do {
            let orderParameters = try createStopLimitOrderParameters(for: orderInput)
            
            if orderInput.clean {
                do {
                    try await kucoinFuturesCancelStopOrders(symbol: orderInput.contractSymbol)
                } catch {
                    logger.log("Could not cancel untriggered stop orders: \(error)")
                }
            }
            
            let request = KucoinFuturesPlaceOrdersRequest(
                orderParameters: orderParameters,
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
                let swiftTraderError = handle(networkRequestError: error, operation: .kucoinFuturesPlaceStopLimitOrder)
                return .failure(swiftTraderError)
            }
        } catch {
            if let swiftTraderError = error as? SwiftTraderError {
                return .failure(swiftTraderError)
            } else {
                return .failure(.unexpected(error))
            }
        }
    }
    
    // MARK: Cancel Orders
    
    /// Cancels all untriggered Futures stop orders of a given symbol (contract).
    ///
    /// https://docs.kucoin.com/futures/#stop-order-mass-cancelation
    ///
    /// - Parameter symbol: `String`, represents the specific contract for which all the untriggered stop orders will be cancelled.
    /// - Returns: An instance of `KucoinFuturesCancelStopOrders` or `SwiftTraderError`.
    @discardableResult func kucoinFuturesCancelStopOrders(symbol: String) async throws -> Result<KucoinFuturesCancelStopOrders, SwiftTraderError> {
        let request = KucoinFuturesCancelOrdersRequest(
            symbol: symbol,
            kucoinAuth: kucoinAuth,
            settings: settings.networkRequestSettings
        )
        switch await request.execute() {
        case .success(let model):
            guard let cancelledOrders = model as? KucoinFuturesCancelStopOrders else {
                return .failure(.unexpectedResponse(modelString: "\(model)"))
            }
            return .success(cancelledOrders)
        case .failure(let error):
            let swiftTraderError = handle(networkRequestError: error, operation: .kucoinFuturesCancelStopOrders)
            return .failure(swiftTraderError)
        }
    }
    
    // MARK: Positions
    
    /// Lists open Futures positions.
    ///
    /// https://docs.kucoin.com/futures/#get-position-list
    ///
    /// - Returns: An instance of `KucoinFuturesPositionList` or `SwiftTraderError`.
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
                return .kucoinFuturesAccountOverview(error: networkRequestError)
            case .kucoinFuturesCancelStopOrders:
                return .kucoinFuturesCancelStopOrders(error: networkRequestError)
            case .kucoinFuturesOrderList:
                return .kucoinOrderList(error: networkRequestError)
            case .kucoinFuturesPlaceStopLimitOrder:
                return .kucoinPlaceStopLimitOrder(error: networkRequestError)
            case .kucoinFuturesPositionList:
                return .kucoinPositionList(error: networkRequestError)
            }
        }
    }
}
