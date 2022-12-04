//
//  SwiftTrader+BinanceSpot.swift
//  
//
//  Created by Fernando Fernandes on 04.12.22.
//

import Foundation

/// Interface to Binance APIs.
public extension SwiftTrader {

    // MARK: - Orders

    /// Places a new order.
    ///
    /// https://binance-docs.github.io/apidocs/spot/en/#new-order-trade
    ///
    /// - Parameter orderInput: `SwiftTraderStopLimitOrderInput` instance that encapsulates
    /// all the arguments required for submiting the stop limit order.
    /// - Returns: An instance of `BinanceNewOrderResponse` or `SwiftTraderError`.
    func binanceSpotNewStopLimitOrder(_ orderInput: SwiftTraderStopLimitOrderInput) async throws -> Result<BinanceSpotNewOrderResponse, SwiftTraderError> {
        guard let auth = binanceAuth else {
            return .failure(.binanceMissingAuthentication)
        }
        do {
            let stopLimitPrice = try calculateStopLimitPrice(for: orderInput)
            
            #warning("TODO: how to handle cancelling order within Binance")
//            if orderInput.cancelStopOrders {
//                do {
//                    try await kucoinSpotCancelStopOrders(symbol: orderInput.contractSymbol)
//                } catch {
//                    logger.log("Could not cancel untriggered stop orders: \(error)")
//                }
//            }
            
            let orderParameters = BinanceSpotNewOrderParameters(
                symbol: orderInput.contractSymbol
            )

            let request = BinanceSpotNewOrderRequest(
                orderParameters: orderParameters,
                binanceAuth: auth,
                settings: settings.networkRequestSettings
            )
            switch await request.execute() {
            case .success(let model):
                guard let placeOrder = model as? BinanceSpotNewOrderResponse else {
                    return .failure(.unexpectedResponse(modelString: "\(model)"))
                }
                return .success(placeOrder)
            case .failure(let error):
                let swiftTraderError = handle(networkRequestError: error, operation: .binanceSpotNewStopLimitOrder)
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
}

