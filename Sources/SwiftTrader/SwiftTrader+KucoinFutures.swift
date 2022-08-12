//
//  SwiftTrader+Kucoin.swift
//  
//
//  Created by Fernando Fernandes on 07.03.22.
//

import Foundation

/// Interface to Kucoin APIs.
public extension SwiftTrader {
    
    // MARK: - Account Overview
    
    /// Retrieves the overview of a Kucoin Futures account.
    ///
    /// https://docs.kucoin.com/futures/#account
    ///
    /// - Parameter currencySymbol: The `CurrencySymbol` of the account balance. The default is `.USDT`.
    /// - Returns: An instance of `KucoinFuturesAccountOverview` or `SwiftTraderError`.
    func kucoinFuturesAccountOverview(currencySymbol: CurrencySymbol = .USDT) async throws -> Result<KucoinFuturesAccountOverview, SwiftTraderError> {
        guard let auth = kucoinAuth else {
            return .failure(.kucoinMissingAuthentication)
        }
        let request = KucoinFuturesAccountOverviewRequest(
            currencySymbol: currencySymbol,
            kucoinAuth: auth,
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
    
    // MARK: - List Orders
    
    /// Retrieves the list of un-triggered stop orders.
    ///
    /// https://docs.kucoin.com/futures/#get-untriggered-stop-order-list
    ///
    /// - Parameter orderStatus: `KucoinFuturesOrderStatus`, default is `.active`.
    /// - Returns: An instance of `KucoinFuturesOrderList` or `SwiftTraderError`.
    func kucoinFuturesStopOrderList(symbol: String) async throws -> Result<KucoinFuturesOrderList, SwiftTraderError> {
        guard let auth = kucoinAuth else {
            return .failure(.kucoinMissingAuthentication)
        }
        let request = KucoinFuturesListStopOrdersRequest(
            symbol: symbol,
            kucoinAuth: auth,
            settings: settings.networkRequestSettings
        )
        switch await request.execute() {
        case .success(let model):
            guard let stopOrders = model as? KucoinFuturesOrderList else {
                return .failure(.unexpectedResponse(modelString: "\(model)"))
            }
            return .success(stopOrders)
        case .failure(let error):
            let swiftTraderError = handle(networkRequestError: error, operation: .kucoinFuturesStopOrderList)
            return .failure(swiftTraderError)
        }
    }
    
    /// Retrieves the list of active Futures orders.
    ///
    /// Notice: this does **not** include the list of stop orders
    /// https://docs.kucoin.com/futures/#get-order-list
    ///
    /// - Parameter orderStatus: `KucoinFuturesOrderStatus`, default is `.active`.
    /// - Returns: An instance of `KucoinFuturesOrderList` or `SwiftTraderError`.
    func kucoinFuturesOrderList(orderStatus: KucoinOrderStatus = .active) async throws -> Result<KucoinFuturesOrderList, SwiftTraderError> {
        guard let auth = kucoinAuth else {
            return .failure(.kucoinMissingAuthentication)
        }
        let request = KucoinFuturesOrdersListRequest(
            orderStatus: orderStatus,
            kucoinAuth: auth,
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
    
    // MARK: - Place Orders
    
    /// Places a Futures stop limit order.
    ///
    /// https://docs.kucoin.com/futures/#place-an-order
    ///
    /// - Parameter orderInput: `SwiftTraderStopLimitOrderInput` instance that encapsulates
    /// all the arguments required for submiting the stop limit order.
    /// - Returns: An instance of `KucoinPlaceOrderResponse` or `SwiftTraderError`.
    func kucoinFuturesPlaceStopLimitOrder(_ orderInput: SwiftTraderStopLimitOrderInput) async throws -> Result<KucoinPlaceOrderResponse, SwiftTraderError> {
        guard let auth = kucoinAuth else {
            return .failure(.kucoinMissingAuthentication)
        }
        do {
            let stopLimitPrice = try calculateStopLimitPrice(for: orderInput)
            
            if orderInput.cancelStopOrders {
                do {
                    try await kucoinFuturesCancelStopOrders(symbol: orderInput.contractSymbol)
                } catch {
                    logger.log("Could not cancel untriggered stop orders: \(error)")
                }
            }
            
            let orderParameters = KucoinFuturesOrderParameters(
                symbol: orderInput.contractSymbol,
                side: .sell,
                type: .limit,
                stop: orderInput.isLong ? .down : .up,
                stopPriceType: .TP,
                stopPrice: stopLimitPrice.stop.string,
                price: stopLimitPrice.limit.string,
                reduceOnly: true,
                closeOrder: true
            )
            
            let request = KucoinFuturesPlaceOrdersRequest(
                orderParameters: orderParameters,
                kucoinAuth: auth,
                settings: settings.networkRequestSettings
            )
            switch await request.execute() {
            case .success(let model):
                guard let placeOrder = model as? KucoinPlaceOrderResponse else {
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
    
    // MARK: - Cancel Orders
    
    /// Cancels all untriggered Futures stop orders of a given symbol (contract).
    ///
    /// https://docs.kucoin.com/futures/#stop-order-mass-cancelation
    ///
    /// - Parameter symbol: `String`, represents the specific contract for which all the untriggered stop orders will be cancelled.
    /// - Returns: An instance of `KucoinFuturesCancelStopOrders` or `SwiftTraderError`.
    @discardableResult func kucoinFuturesCancelStopOrders(symbol: String) async throws -> Result<KucoinCancelStopOrdersResponse, SwiftTraderError> {
        guard let auth = kucoinAuth else {
            return .failure(.kucoinMissingAuthentication)
        }
        let request = KucoinFuturesCancelOrdersRequest(
            symbol: symbol,
            kucoinAuth: auth,
            settings: settings.networkRequestSettings
        )
        switch await request.execute() {
        case .success(let model):
            guard let cancelledOrders = model as? KucoinCancelStopOrdersResponse else {
                return .failure(.unexpectedResponse(modelString: "\(model)"))
            }
            return .success(cancelledOrders)
        case .failure(let error):
            let swiftTraderError = handle(networkRequestError: error, operation: .kucoinFuturesCancelStopOrders)
            return .failure(swiftTraderError)
        }
    }
    
    // MARK: - Positions
    
    /// Lists open Futures positions.
    ///
    /// https://docs.kucoin.com/futures/#get-position-list
    ///
    /// - Returns: An instance of `KucoinFuturesPositionList` or `SwiftTraderError`.
    func kucoinFuturesPositionList() async throws -> Result<KucoinFuturesPositionList, SwiftTraderError> {
        guard let auth = kucoinAuth else {
            return .failure(.kucoinMissingAuthentication)
        }
        let request = KucoinFuturesPositionListRequest(
            kucoinAuth: auth,
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
