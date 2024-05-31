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

    /// Places multiple **long** **limit** orders.
    ///
    /// This function calculates the distance of the price of each order using the parameters of the given
    /// `SwiftTraderMultiLongLimitOrderInput` instance.
    ///
    /// [Kucoin](https://www.kucoin.com/docs/rest/spot-trading/spot-hf-trade-pro-account/place-multiple-orders)
    ///
    /// - Parameter orderInput: `SwiftTraderMultiLongLimitOrderInput` instance that encapsulates
    /// all the arguments required for submitting multiple long limit orders (five) against one asset.
    /// - Returns: An instance of `KucoinSpotHFLongLimitOrdersResult` or `SwiftTraderError`.
    /// The `KucoinSpotHFLongLimitOrdersResult` encapsulates all the submitted orders, including prices and sizes.
    ///
    /// - Note: Five orders are created at once; the number can't go higher, as this is a limitation of the Kucoin API.
    ///
    /// - Example: consider a new listed coin called "NEW"; the strategy is to create five buy orders for it as soon as
    /// it gets listed, based on its current max bid. Via the `orderInput`, the price of the *first order* is set to be
    /// 26% higher, while subsequent order prices are set to be 1% higher (compared to previous prices).
    ///
    /// In short:
    ///   - The current max bid of NEW-USDT is "0.046"
    ///     - (`SwiftTraderMultiLongLimitOrderInput.initialPrice`)
    ///   - The first order should be above the max bid by 0.26
    ///     - (`SwiftTraderMultiLongLimitOrderInput.initialPriceIncrement`)
    ///   - The 2ⁿᵈ, 3ʳᵈ, 4ᵗʰ, and 5ᵗʰ price orders should be equal to the previous price order incremented by 0.01
    ///     - (`SwiftTraderMultiLongLimitOrderInput.priceIncrement`)
    ///   - The total funds for the five orders is 260
    ///     - (`SwiftTraderMultiLongLimitOrderInput.totalFunds`)
    ///
    ///  Based on the above input, the price and size for the five buy/limit NEW-USDT orders will be:
    ///   ```
    ///   Prices:
    ///   "0.058" // 0.26% of the highest bid
    ///   "0.059" // 0.01% of the previous order price
    ///   "0.060" // 0.01% of the previous order price
    ///   "0.061" // 0.01% of the previous order price
    ///   "0.062" // 0.01% of the previous order price
    ///
    ///   Sizes (the function rounds down the size to the nearest whole number):
    ///   "896" // (260/5)/price of first order
    ///   "881" // (260/5)/price of second order
    ///   "866" // (260/5)/price of third order
    ///   "852" // (260/5)/price of fourth order
    ///   "838" // (260/5)/price of fifth order
    ///   ```
    ///
    ///   When dealing with new listings, it's crucial to try entering a position as quickly as possible,
    ///   even if that means paying more.
    ///
    ///   To quickly exit the position is as important, so just after the above buying orders are submitted,
    ///   one could trigger five selling orders targeting the desired profit percentage, for example,
    ///   60% (conservative), 100% or 200% of the given highest bid or last order price
    ///   (some new listings could go as high as 800%, or even more).
    func kucoinSpotHFPlaceMultipleLongLimitOrders(
        _ orderInput: SwiftTraderMultiLongLimitOrderInput
    ) async throws -> Result<KucoinSpotHFLongLimitOrdersResult, SwiftTraderError> {

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
            guard let response = model as? KucoinHFPlaceMultiOrdersResponse else {
                return .failure(.unexpectedResponse(modelString: "\(model)"))
            }
            return .success(.init(orders: request.orders, response: response))
        case .failure(let error):
            let swiftTraderError = handle(
                networkRequestError: error,
                operation: .kucoinSpotHFPlaceMultiLongLimitOrders
            )
            return .failure(swiftTraderError)
        }
    }

    /// Places multiple **short** **limit** orders.
    ///
    /// This function calculates the distance of the price of each order using the parameters of the given
    /// `SwiftTraderMultiShortLimitOrderInput` instance.
    ///
    /// [Kucoin](https://www.kucoin.com/docs/rest/spot-trading/spot-hf-trade-pro-account/place-multiple-orders)
    ///
    /// - Parameter orderInput: `SwiftTraderMultiShortLimitOrderInput` instance that encapsulates
    /// all the arguments required for submitting multiple short limit orders (five) against one asset.
    /// - Returns: An instance of `KucoinSpotHFShortLimitOrdersResult` or `SwiftTraderError`.
    /// The `KucoinSpotHFShortLimitOrdersResult` encapsulates all the submitted orders, including prices and sizes.
    ///
    /// - Note: Five orders are created at once; the number can't go higher, as this is a limitation of the Kucoin API.
    ///
    /// - Example: consider a coin called "NEW", with a total of 4333 units acquired. The strategy involves creating
    /// five orders, each with a size of 4333 units. Using the `orderInput`, the cost of the first order is 66% higher
    /// than a chosen initial price, while the prices of subsequent orders are 1% higher than the previous ones.
    ///
    /// In short:
    ///   - The chosen initial NEW-USDT price is "0.046"
    ///     - (`SwiftTraderMultiShortLimitOrderInput.initialPrice`)
    ///   - The first order should be above the max bid by 0.66
    ///     - (`SwiftTraderMultiShortLimitOrderInput.targetProfitPercentage`)
    ///   - The 2ⁿᵈ, 3ʳᵈ, 4ᵗʰ, and 5ᵗʰ price orders should be equal to the previous price order decremented by 0.01
    ///     - (`SwiftTraderMultiShortLimitOrderInput.priceDecrement`)
    ///   - The total size available is 4333
    ///     - (`SwiftTraderMultiShortLimitOrderInput.totalSize`)
    ///
    ///  Based on the above input, the price and size for the five short/limit NEW-USDT orders will be:
    ///   ```
    ///   Prices:
    ///   "0.076" // 0.66% of the chosen initial price
    ///   "0.075" // 0.01% of the previous order price
    ///   "0.074" // 0.01% of the previous order price
    ///   "0.073" // 0.01% of the previous order price
    ///   "0.072" // 0.01% of the previous order price
    ///
    ///   Order size (the function rounds down the size to the nearest whole number):
    ///   "4333" // Each one of the five orders has the same size
    ///   ```
    ///
    ///   Profits can be maximized by setting the same size for all selling orders. Once one selling order is filled
    ///   (hopefully the one with the highest price), all available assets are sold,
    ///   bringing the highest possible return.
    func kucoinSpotHFPlaceMultipleShortLimitOrders(
        _ orderInput: SwiftTraderMultiShortLimitOrderInput
    ) async throws -> Result<KucoinSpotHFShortLimitOrdersResult, SwiftTraderError> {

        guard let auth = kucoinAuth else {
            return .failure(.kucoinMissingAuthentication)
        }

        let request = KucoinSpotHFPlaceMultiOrdersRequest(
            orders: createMultipleShortLimitOrders(for: orderInput),
            kucoinAuth: auth,
            settings: settings.networkRequestSettings
        )

        switch await request.execute() {
        case .success(let model):
            guard let response = model as? KucoinHFPlaceMultiOrdersResponse else {
                return .failure(.unexpectedResponse(modelString: "\(model)"))
            }
            return .success(.init(orders: request.orders, response: response))
        case .failure(let error):
            let swiftTraderError = handle(
                networkRequestError: error,
                operation: .kucoinSpotHFPlaceMultiShortLimitOrders
            )
            return .failure(swiftTraderError)
        }
    }
}
