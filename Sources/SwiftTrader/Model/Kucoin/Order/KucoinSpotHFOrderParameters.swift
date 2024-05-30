//
//  KucoinSpotHFOrderParameters.swift
//
//
//  Created by Fernando Fernandes on 23.05.24.
//

import Foundation

/// Encapsulates parameters to place a spot HF order.
///
/// https://www.kucoin.com/docs/rest/spot-trading/spot-hf-trade-pro-account/place-hf-order
public struct KucoinSpotHFOrderParameters: Equatable, Codable {

    // MARK: - Properties

    public let clientOid: String
    public let symbol: String
    public let type: KucoinOrderType
    public let size: String
    public let price: String
    public let side: OrderSide

    // MARK: - Lifecycle

    public init(clientOid: String = UUID().uuidString,
                symbol: String,
                type: KucoinOrderType,
                size: String,
                price: String,
                side: OrderSide) {
        self.clientOid = clientOid
        self.symbol = symbol
        self.type = type
        self.size = size
        self.price = price
        self.side = side
    }
}
