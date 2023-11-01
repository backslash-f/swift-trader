//
//  BinanceSpotNewOrderResponse.swift
//  
//
//  Created by Fernando Fernandes on 04.12.22.
//

import Foundation

/// Binance "New Order" REST API response.
///
/// https://binance-docs.github.io/apidocs/spot/en/#new-order-trade
public struct BinanceSpotNewOrderResponse: Codable {
    let symbol: String
    let orderID, orderListID: Int
    let clientOrderID: String
    let transactTime: Int
    let price, origQty, executedQty, cummulativeQuoteQty: String
    let status, timeInForce, type, side: String
    let workingTime: Int
    let fills: [BinanceOrderFill]
    let selfTradePreventionMode: String

    enum CodingKeys: String, CodingKey {
        case orderID = "orderId"
        case orderListID = "orderListId"
        case clientOrderID = "clientOrderId"
        case symbol, transactTime, price, origQty, executedQty, cummulativeQuoteQty, status, timeInForce, type, side
        case workingTime, fills, selfTradePreventionMode
    }
}

public struct BinanceOrderFill: Codable {
    let price, qty, commission, commissionAsset: String
    let tradeID: Int

    enum CodingKeys: String, CodingKey {
        case price, qty, commission, commissionAsset
        case tradeID = "tradeId"
    }
}
