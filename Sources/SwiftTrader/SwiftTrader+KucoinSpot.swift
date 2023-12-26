//
//  SwiftTrader+KucoinSpot.swift
//  
//
//  Created by Fernando Fernandes on 16.07.22.
//

import Foundation

/// Interface to Kucoin APIs.
public extension SwiftTrader {

    // MARK: - List Accounts

    /// Gets the list of accounts.
    ///
    /// There are three types of accounts: 1) main account 2) trade account 3) margin account.
    ///
    /// https://docs.kucoin.com/#list-accounts
    ///
    /// - Parameter currencySymbol: The `CurrencySymbol` of the account balance. The default is `.USDT`.
    /// - Returns: An instance of `KucoinSpotListAccounts` or `SwiftTraderError`.
    func kucoinSpotListAccounts(
        currencySymbol: CurrencySymbol = .USDT
    ) async throws -> Result<KucoinSpotListAccountsResponse, SwiftTraderError> {
        guard let auth = kucoinAuth else {
            return .failure(.kucoinMissingAuthentication)
        }
        let request = KucoinListAccountsRequest(
            currencySymbol: currencySymbol,
            kucoinAuth: auth,
            settings: settings.networkRequestSettings
        )
        switch await request.execute() {
        case .success(let model):
            guard let accounts = model as? KucoinSpotListAccountsResponse else {
                return .failure(.unexpectedResponse(modelString: "\(model)"))
            }
            return .success(accounts)
        case .failure(let error):
            let swiftTraderError = handle(networkRequestError: error, operation: .kucoinSpotListAccounts)
            return .failure(swiftTraderError)
        }
    }

    // MARK: - Account

    /// Retrieves information for a single account.
    ///
    /// https://docs.kucoin.com/#get-an-account
    ///
    /// - Parameter accountID: The ID of the account.
    /// - Returns: An instance of of `KucoinSpotGetAccount` or `SwiftTraderError`.
    func kucoinSpotGetAccount(
        accountID: String
    ) async throws -> Result<KucoinSpotGetAccountResponse, SwiftTraderError> {
        guard let auth = kucoinAuth else {
            return .failure(.kucoinMissingAuthentication)
        }
        let request = KucoinGetAccountRequest(
            accountID: accountID,
            kucoinAuth: auth,
            settings: settings.networkRequestSettings
        )
        switch await request.execute() {
        case .success(let model):
            guard let accounts = model as? KucoinSpotGetAccountResponse else {
                return .failure(.unexpectedResponse(modelString: "\(model)"))
            }
            return .success(accounts)
        case .failure(let error):
            let swiftTraderError = handle(networkRequestError: error, operation: .kucoinSpotGetAccount)
            return .failure(swiftTraderError)
        }
    }

    // MARK: - Transferable

    /// Returns the transferable balance of a specified account.
    ///
    /// https://docs.kucoin.com/#get-the-transferable
    ///
    /// - Parameter currencySymbol: The `CurrencySymbol` of the account balance. The default is `.USDT`.
    /// - Returns: An instance of of `KucoinSpotGetTransferableResponse` or `SwiftTraderError`.
    func kucoinSpotGetTransferable(
        currencySymbol: CurrencySymbol = .USDT
    ) async throws -> Result<KucoinSpotGetTransferableResponse, SwiftTraderError> {
        guard let auth = kucoinAuth else {
            return .failure(.kucoinMissingAuthentication)
        }
        let request = KucoinGetTransferableRequest(
            currencySymbol: currencySymbol,
            kucoinAuth: auth,
            settings: settings.networkRequestSettings
        )
        switch await request.execute() {
        case .success(let model):
            guard let transferable = model as? KucoinSpotGetTransferableResponse else {
                return .failure(.unexpectedResponse(modelString: "\(model)"))
            }
            return .success(transferable)
        case .failure(let error):
            let swiftTraderError = handle(networkRequestError: error, operation: .kucoinSpotGetTransferable)
            return .failure(swiftTraderError)
        }
    }

    // MARK: - Orders

    /// Places a spot stop limit order.
    ///
    /// https://docs.kucoin.com/#place-a-new-order
    ///
    /// - Parameter orderInput: `SwiftTraderStopLimitOrderInput` instance that encapsulates
    /// all the arguments required for submiting the stop limit order.
    /// - Returns: An instance of `KucoinPlaceOrderResponse` or `SwiftTraderError`.
    func kucoinSpotPlaceStopLimitOrder(
        _ orderInput: SwiftTraderStopLimitOrderInput
    ) async throws -> Result<KucoinPlaceOrderResponse, SwiftTraderError> {
        guard let auth = kucoinAuth else {
            return .failure(.kucoinMissingAuthentication)
        }
        do {
            let stopLimitPrice = try calculateStopLimitPrice(for: orderInput)

            if orderInput.cancelStopOrders {
                do {
                    try await kucoinSpotCancelStopOrders(symbol: orderInput.contractSymbol)
                } catch {
                    logger.log("Could not cancel untriggered stop orders: \(error)")
                }
            }

            let orderParameters = KucoinSpotOrderParameters(
                side: orderInput.isLong ? .sell : .buy,
                symbol: orderInput.contractSymbol,
                type: .limit,
                stop: orderInput.isLong ? .loss : .entry,
                stopPrice: stopLimitPrice.stop.string,
                price: stopLimitPrice.limit.string,
                size: "\(orderInput.size)"
            )

            let request = KucoinSpotPlaceOrdersRequest(
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
                let swiftTraderError = handle(networkRequestError: error, operation: .kucoinSpotPlaceStopLimitOrder)
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

    /// Lists active Spot orders.
    ///
    /// https://docs.kucoin.com/#list-orders
    ///
    /// - Returns: An instance of `KucoinSpotOrderListResponse` or `SwiftTraderError`.
    func kucoinSpotOrderList() async throws -> Result<KucoinSpotOrderListResponse, SwiftTraderError> {
        guard let auth = kucoinAuth else {
            return .failure(.kucoinMissingAuthentication)
        }
        let request = KucoinSpotOrdersListRequest(
            kucoinAuth: auth,
            settings: settings.networkRequestSettings
        )
        switch await request.execute() {
        case .success(let model):
            guard let positionList = model as? KucoinSpotOrderListResponse else {
                return .failure(.unexpectedResponse(modelString: "\(model)"))
            }
            return .success(positionList)
        case .failure(let error):
            let swiftTraderError = handle(networkRequestError: error, operation: .kucoinSpotOrderList)
            return .failure(swiftTraderError)
        }
    }

    /// Lists active Spot **stop** orders.
    ///
    /// https://docs.kucoin.com/#list-stop-orders
    ///
    /// - Returns: An instance of `KucoinSpotStopOrderListResponse` or `SwiftTraderError`.
    func kucoinSpotStopOrderList() async throws -> Result<KucoinSpotStopOrderListResponse, SwiftTraderError> {
        guard let auth = kucoinAuth else {
            return .failure(.kucoinMissingAuthentication)
        }
        let request = KucoinSpotStopOrdersListRequest(
            kucoinAuth: auth,
            settings: settings.networkRequestSettings
        )
        switch await request.execute() {
        case .success(let model):
            guard let positionList = model as? KucoinSpotStopOrderListResponse else {
                return .failure(.unexpectedResponse(modelString: "\(model)"))
            }
            return .success(positionList)
        case .failure(let error):
            let swiftTraderError = handle(networkRequestError: error, operation: .kucoinSpotStopOrderList)
            return .failure(swiftTraderError)
        }
    }

    /// Cancels all untriggered stop orders of a given symbol (contract).
    ///
    /// https://docs.kucoin.com/#cancel-orders
    ///
    /// - Parameter symbol: `String`, represents the specific contract for which all the
    /// untriggered stop orders will be cancelled.
    /// - Returns: An instance of `KucoinCancelStopOrdersResponse` or `SwiftTraderError`.
    @discardableResult func kucoinSpotCancelStopOrders(
        symbol: String
    ) async throws -> Result<KucoinCancelStopOrdersResponse, SwiftTraderError> {
        guard let auth = kucoinAuth else {
            return .failure(.kucoinMissingAuthentication)
        }
        let request = KucoinSpotCancelOrdersRequest(
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
            let swiftTraderError = handle(networkRequestError: error, operation: .kucoinSpotCancelStopOrders)
            return .failure(swiftTraderError)
        }
    }

    // MARK: - WebSocket

    /// Requests an authorized token for subscribing to private channels and messages via WebSocket.
    ///
    /// https://www.kucoin.com/docs/websocket/basic-info/apply-connect-token/private-channels-authentication-request-required-
    ///
    /// - Returns: An instance of `KucoinWebSocketPrivateTokenResponse` or `SwiftTraderError`.
    @discardableResult func kucoinSpotWebSocketRequestPrivateToken() async throws
    -> Result<KucoinWebSocketPrivateTokenResponse, SwiftTraderError> {
        guard let auth = kucoinAuth else {
            return .failure(.kucoinMissingAuthentication)
        }
        let request = KucoinSpotWebSocketBulletPrivateRequest(
            kucoinAuth: auth,
            settings: settings.networkRequestSettings
        )
        switch await request.execute() {
        case .success(let model):
            guard let privateTokenResponse = model as? KucoinWebSocketPrivateTokenResponse else {
                return .failure(.unexpectedResponse(modelString: "\(model)"))
            }
            return .success(privateTokenResponse)
        case .failure(let error):
            let swiftTraderError = handle(networkRequestError: error, operation: .kucoinSpotWebSocketPrivateToken)
            return .failure(swiftTraderError)
        }
    }
}
