//
//  SwiftTrader+KucoinSpotHF.swift
//
//
//  Created by Fernando Fernandes on 23.05.24.
//

import Foundation

/// Interface to Kucoin HF APIs.
public extension SwiftTrader {

    // MARK: - Orders

    /// Places multiple orders.
    ///
    /// This function calculates the distance of the price of each order
    /// using the parameters of the given `SwiftTraderOrderInput` instance.
    ///
    /// https://www.kucoin.com/docs/rest/spot-trading/spot-hf-trade-pro-account/place-multiple-orders
    ///
    /// - Parameter orderInput: `SwiftTraderMultiLimitOrderInput` instance that encapsulates
    /// all the arguments required for submiting multiple orders against one asset.
    /// - Returns: An instance of `KucoinHFPlaceMultiOrdersResponse` or `SwiftTraderError`.
    ///
    /// - Example: As a simple example on the output of this function:
    ///   - Consider the max bid of PEPE-USDT to be "0.00000121"
    ///  (`SwiftTraderMultiLimitOrderInput.maxBid`)
    ///   - The first order should be above the max bid by 0,16%
    ///  (`SwiftTraderMultiLimitOrderInput.initialPriceIncrement`)
    ///   - The second, third, fourth and fifth orders should increment the previous price by 0,1%
    ///  (`SwiftTraderMultiLimitOrderInput.priceIncrement`)
    ///   - The total funds for the 5 orders is 50
    ///  (`SwiftTraderMultiLimitOrderInput.totalFunds`)
    ///
    ///  Based on the above input, the price and size for the 5 buy/limit PEPE orders will be:
    ///   ```
    ///   Prices:
    ///   "0.00000140", // 0,16% of the maxBid
    ///   "0.00000154", // 0,1% of the previous price
    ///   "0.00000170", // 0,1% of the previous price
    ///   "0.00000187", // 0,1% of the previous price
    ///   "0.00000206"  // 0,1% of the previous price
    ///
    ///   Sizes:
    ///   "7142857", (50/5)/price of first order
    ///   "6493506", (50/5)/price of second order
    ///   "5882352", (50/5)/price of third order
    ///   "5347593", (50/5)/price of fourth order
    ///   "4854368"  (50/5)/price of fifth order
    ///   ```
    func kucoinSpotHFPlaceMultipleOrders(
        _ orderInput: SwiftTraderMultiLimitOrderInput
    ) async throws -> Result<KucoinHFPlaceMultiOrdersResponse, SwiftTraderError> {
        guard let auth = kucoinAuth else {
            return .failure(.kucoinMissingAuthentication)
        }
        let request = KucoinSpotHFPlaceMultiOrdersRequest(
            orders: createMultipleLongLimitOrders(for: orderInput),
            kucoinAuth: auth,
            settings: settings.networkRequestSettings        )
        switch await request.execute() {
        case .success(let model):
            guard let placeOrder = model as? KucoinHFPlaceMultiOrdersResponse else {
                return .failure(.unexpectedResponse(modelString: "\(model)"))
            }
            return .success(placeOrder)
        case .failure(let error):
            let swiftTraderError = handle(networkRequestError: error, operation: .kucoinSpotHFPlaceMultipleOrders)
            return .failure(swiftTraderError)
        }
    }
}
