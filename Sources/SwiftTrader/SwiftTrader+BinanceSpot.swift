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
    /// - Parameter orderInput: `BinanceSpotNewOrderParameters` instance that encapsulates
    /// all the arguments required for submiting the order.
    /// - Returns: An instance of `BinanceNewOrderResponse` or `SwiftTraderError`.
    func binanceSpotNewOrder(_ orderInput: BinanceSpotNewOrderParameters) async throws -> Result<BinanceSpotNewOrderResponse, SwiftTraderError> {
        guard let auth = binanceAuth else {
            return .failure(.binanceMissingAuthentication)
        }
        let request = BinanceSpotNewOrderRequest(
            orderParameters: orderInput,
            binanceAuth: auth,
            settings: settings.networkRequestSettings
        )
        switch await request.execute() {
        case .success(let model):
            guard let placeOrder = model as? BinanceSpotNewOrderResponse else {
                return .failure(.unexpectedResponse(modelString: "\(model)"))
            }
#warning("TODO: how to handle cancelling order within Binance")
            //            if orderInput.cancelStopOrders {
            //                do {
            //                    try await kucoinSpotCancelStopOrders(symbol: orderInput.contractSymbol)
            //                } catch {
            //                    logger.log("Could not cancel untriggered stop orders: \(error)")
            //                }
            //            }
            return .success(placeOrder)
        case .failure(let error):
            let swiftTraderError = handle(networkRequestError: error, operation: .binanceSpotNewOrder)
            return .failure(swiftTraderError)
        }
    }
}

