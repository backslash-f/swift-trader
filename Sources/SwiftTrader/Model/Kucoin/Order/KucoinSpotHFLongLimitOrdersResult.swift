//
//  KucoinSpotHFLongLimitOrdersResult.swift
//
//
//  Created by Fernando Fernandes on 30.05.24.
//

import Foundation

/// Represents the success result of `SwiftTrader.kucoinSpotHFPlaceMultipleLongLimitOrders(_:)`.
///
/// Contains the multiple limit orders created as well as the server response.
///
/// Provides calculated `vars` for checking the submitted prices, sizes, and total size.
public struct KucoinSpotHFLongLimitOrdersResult: Equatable, Codable {
    public let orders: [KucoinSpotHFOrderParameters]
    public let response: KucoinHFPlaceMultiOrdersResponse

    /// An array of the prices of the submitted orders.
    public var prices: [String] {
        orders.map { $0.price }
    }

    /// An array of the sizes of the submitted orders.
    public var sizes: [String] {
        orders.map { $0.size }
    }

    /// The total size of all the submitted orders.
    public var totalSize: Double {
        orders.compactMap { Double($0.size) }.reduce(0, +)
    }
}
