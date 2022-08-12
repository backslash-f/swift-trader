//
//  KucoinSpotOrderParameters.swift
//
//
//  Created by Fernando Fernandes on 12.08.22.
//

import Foundation

/// Encapsulates parameters to place a spot order.
///
/// https://docs.kucoin.com/#place-a-new-order-2
public struct KucoinSpotOrderParameters {

    // MARK: - Properties

    public let clientOid = UUID().uuidString
    public let side: OrderSide
    public let symbol: String
    public let type: KucoinOrderType
    public let stop: KucoinOrderStop.Spot
    public let stopPrice: String
    public let price: String
    public let size: String

    // MARK: - Lifecycle

    public init(side: OrderSide,
                symbol: String,
                type: KucoinOrderType,
                stop: KucoinOrderStop.Spot,
                stopPrice: String,
                price: String,
                size: String) {
        self.side = side
        self.symbol = symbol
        self.type = type
        self.stop = stop
        self.stopPrice = stopPrice
        self.price = price
        self.size = size
    }
}
