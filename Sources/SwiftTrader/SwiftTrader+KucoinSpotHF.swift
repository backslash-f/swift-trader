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
    /// [Kucoin](https://www.kucoin.com/docs/rest/spot-trading/spot-hf-trade-pro-account/place-multiple-orders)
    ///
    /// - Parameter orderInput: `SwiftTraderMultiLimitOrderInput` instance that encapsulates
    /// all the arguments required for submitting multiple orders against one asset.
    /// - Returns: An instance of `KucoinHFPlaceMultiOrdersResponse` or `SwiftTraderError`.
    ///
    /// - Example: consider a new listed coin called "NEW"; the strategy is to create five buy orders for it as soon as
    /// it gets listed, based on its current max bid. Via the `orderInput`, the price of the first order is set to be
    /// 11% higher, while subsequent order prices are set to be 1% higher (compared to previous prices).
    ///
    /// In short:
    ///   - The current max bid of NEW-USDT is "0.046"
    ///     - (`SwiftTraderMultiLimitOrderInput.maxBid`)
    ///   - The first order should be above the max bid by 0.11
    ///     - (`SwiftTraderMultiLimitOrderInput.initialPriceIncrement`)
    ///   - The second, third, fourth, and fifth orders should increment the previous price by 0.01
    ///     - (`SwiftTraderMultiLimitOrderInput.priceIncrement`)
    ///   - The total funds for the five orders is 50
    ///     - (`SwiftTraderMultiLimitOrderInput.totalFunds`)
    ///
    ///  Based on the above input, the price and size for the five buy/limit NEW-USDT orders will be:
    ///   ```
    ///   Prices:
    ///   "0.051" // 0,11% of the highest bid
    ///   "0.052" // 0,01% of the previous price
    ///   "0.053" // 0,01% of the previous price
    ///   "0.054" // 0,01% of the previous price
    ///   "0.055" // 0,01% of the previous price
    ///
    ///   Sizes (the function rounds down the size to the nearest whole number):
    ///   "196" // (50/5)/price of first order
    ///   "192" // (50/5)/price of second order
    ///   "188" // (50/5)/price of third order
    ///   "185" // (50/5)/price of fourth order
    ///   "181" // (50/5)/price of fifth order
    ///   ```
    ///
    ///   When dealing with new listings, it's crucial to try entering a position as quickly as possible,
    ///   even if that means paying more.
    ///
    ///   To quickly exit the position is as important, so just after the above buying orders are submitted,
    ///   one could trigger five selling orders targeting the desired profit percentage, for example,
    ///   60% (conservative), 100% or 200% of the given highest bid or last order price
    ///   (some new listings could go as high as 800%, or even more).
    func kucoinSpotHFPlaceMultipleOrders(
        _ orderInput: SwiftTraderMultiLimitOrderInput
    ) async throws -> Result<KucoinHFPlaceMultiOrdersResponse, SwiftTraderError> {
        
        guard let auth = kucoinAuth else {
            return .failure(.kucoinMissingAuthentication)
        }
        
        let request = KucoinSpotHFPlaceMultiOrdersRequest(
            orders: createMultipleLongLimitOrders(for: orderInput),
            kucoinAuth: auth,
            settings: settings.networkRequestSettings
        )
        
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
