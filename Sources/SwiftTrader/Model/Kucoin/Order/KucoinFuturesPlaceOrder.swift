//
//  KucoinFuturesPlaceOrder.swift
//  
//
//  Created by Fernando Fernandes on 07.02.22.
//

import Foundation

/// Kucoin "Place an Order" REST API response.
///
/// https://docs.kucoin.com/futures/#place-an-order
public struct KucoinFuturesPlaceOrder: Codable {
    public let code: String
    public let data: KucoinFuturesOrderPlaced
}

public struct KucoinFuturesOrderPlaced: Codable {
    public let orderId: String
}
