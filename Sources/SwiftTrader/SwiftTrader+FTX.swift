//
//  SwiftTrader+FTX.swift
//
//
//  Created by Fernando Fernandes on 07.03.22.
//

import Foundation

/// Interface to FTX APIs.
public extension SwiftTrader {
    
    // MARK: - Cancel Orders
    
    /// Cancels all open orders.
    ///
    /// https://docs.ftx.com/?python#cancel-all-orders
    ///
    /// - Parameter cancelOrderParameters: `FTXCancelOrderParameters` that defines the orders to be cancelled..
    /// - Returns: An instance of `FTXCancelOrder` or `SwiftTraderError`.
    @discardableResult func cancelAllOrders(cancelOrderParameters: FTXCancelOrderParameters) async throws -> Result<FTXCancelOrder, SwiftTraderError> {
        guard let auth = ftxAuth else {
            return .failure(.ftxMissingAuthentication)
        }
        let request = FTXCancelAllOrdersRequest(
            cancelOrderParameters: cancelOrderParameters,
            ftxAuth: auth,
            settings: settings.networkRequestSettings
        )
        switch await request.execute() {
        case .success(let model):
            guard let cancelOrder = model as? FTXCancelOrder else {
                return .failure(.unexpectedResponse(modelString: "\(model)"))
            }
            return .success(cancelOrder)
        case .failure(let error):
            let swiftTraderError = handle(networkRequestError: error, operation: .ftxCancelAllOrders)
            return .failure(swiftTraderError)
        }
    }
    
    // MARK: - Place Orders
    
    /// Places a stop limit order within FTX.
    ///
    /// They call it a "trigger order".
    /// https://docs.ftx.com/?python#place-trigger-order
    ///
    /// - Parameter orderInput: `SwiftTraderStopLimitOrderInput` instance that encapsulates
    /// all the arguments required for submiting the stop limit order.
    /// - Returns: An instance of `FTXPlaceTriggerOrder` or `SwiftTraderError`.
    func ftxPlaceStopLimitOrder(_ orderInput: SwiftTraderStopLimitOrderInput) async throws -> Result<FTXPlaceTriggerOrder, SwiftTraderError> {
        guard let auth = ftxAuth else {
            return .failure(.ftxMissingAuthentication)
        }
        guard orderInput.size > 0 else {
            return .failure(.ftxInvalidSize)
        }
        do {
            let stopLimitPrice = try calculateStopLimitPrice(for: orderInput)
            
            if orderInput.cancelStopOrders {
                do {
                    let cancelOrderParameters = FTXCancelOrderParameters(
                        market: orderInput.contractSymbol,
                        side: .sell,
                        conditionalOrdersOnly: true,
                        limitOrdersOnly: false
                    )
                    try await cancelAllOrders(cancelOrderParameters: cancelOrderParameters)
                } catch {
                    logger.log("Could not cancel untriggered stop orders: \(error)")
                }
            }
            
            let orderParameters = FTXTriggerOrderParameters(
                market: orderInput.contractSymbol,
                side: .sell,
                size: orderInput.size,
                type: .stop,
                reduceOnly: true,
                retryUntilFilled: true,
                triggerPrice: stopLimitPrice.stop.double,
                orderPrice: stopLimitPrice.limit.double
            )
            
            let request = FTXPlaceOrderRequest(
                orderParameters: orderParameters,
                ftxAuth: auth,
                settings: settings.networkRequestSettings
            )
            switch await request.execute() {
            case .success(let model):
                guard let placeOrder = model as? FTXPlaceTriggerOrder else {
                    return .failure(.unexpectedResponse(modelString: "\(model)"))
                }
                return .success(placeOrder)
            case .failure(let error):
                let swiftTraderError = handle(networkRequestError: error, operation: .ftxPlaceStopLimitOrder)
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
    
    // MARK: Positions
    
    /// Lists open positions.
    ///
    /// https://docs.ftx.com/#get-positions
    ///
    /// - Returns: An instance of `FTXPositionList` or `SwiftTraderError`.
    func ftxPositions() async throws -> Result<FTXPositionList, SwiftTraderError> {
        guard let auth = ftxAuth else {
            return .failure(.ftxMissingAuthentication)
        }
        let request = FTXPositionListRequest(
            ftxAuth: auth,
            settings: settings.networkRequestSettings
        )
        switch await request.execute() {
        case .success(let model):
            guard let positionList = model as? FTXPositionList else {
                return .failure(.unexpectedResponse(modelString: "\(model)"))
            }
            return .success(positionList)
        case .failure(let error):
            let swiftTraderError = handle(networkRequestError: error, operation: .ftxPositions)
            return .failure(swiftTraderError)
        }
    }
}
