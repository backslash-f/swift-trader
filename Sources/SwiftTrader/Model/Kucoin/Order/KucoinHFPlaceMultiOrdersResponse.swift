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
public struct KucoinHFPlaceMultiOrdersResponse: Equatable, Codable {
    let code: String
    let data: [Data]

    public struct Data: Equatable, Codable {
        public let success: Bool
        public let orderID: String?
        public let failMsg: String?

        enum CodingKeys: String, CodingKey {
            case success
            case orderID = "orderId"
            case failMsg
        }
    }
}
