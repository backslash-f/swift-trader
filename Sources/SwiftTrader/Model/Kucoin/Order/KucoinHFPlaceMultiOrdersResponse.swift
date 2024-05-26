//
//  KucoinHFPlaceMultiOrdersResponse.swift
//
//
//  Created by Fernando Fernandes on 23.05.24.
//

import Foundation

/// Kucoin "Place Multiple Orders" HF REST API response.
///
/// https://www.kucoin.com/docs/rest/spot-trading/spot-hf-trade-pro-account/place-multiple-orders
public struct KucoinHFPlaceMultiOrdersResponse: Codable {
    public let success: Bool
    public let code, msg: String
    public let retry: Bool
    public let data: [Data]

    public struct Data: Codable {
        public let orderID: String
        public let success: Bool

        enum CodingKeys: String, CodingKey {
            case orderID = "orderId"
            case success
        }
    }
}
