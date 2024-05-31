//
//  KucoinSpotHFShortLimitOrdersResult.swift
//
//
//  Created by Fernando Fernandes on 31.05.24.
//

import Foundation

/// Represents the success result of `SwiftTrader.kucoinSpotHFPlaceMultipleShortLimitOrders(_:)`.
///
/// Contains all the submitted short limit orders, as well as the server response.
///
/// Provides calculated `vars` for checking the submitted prices, and sizes.
public struct KucoinSpotHFShortLimitOrdersResult: Equatable, Codable {
    public let orders: [KucoinSpotHFOrderParameters]
    public let response: KucoinHFPlaceMultiOrdersResponse

    /// An array of the prices of the submitted orders.
    public var prices: [String] {
        orders.map { $0.price }
    }

    public var sizes: [String] {
        orders.map { $0.size }
    }
}
