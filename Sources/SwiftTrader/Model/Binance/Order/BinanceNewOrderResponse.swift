//
//  BinanceNewOrderResponse.swift
//  
//
//  Created by Fernando Fernandes on 04.12.22.
//

import Foundation

/// Binance "New Order" REST API response.
///
/// https://binance-docs.github.io/apidocs/spot/en/#new-order-trade
public struct BinanceNewOrderResponse: Codable {
    let symbol: String
    let orderID, orderListID: Int
    let clientOrderID: String
    let transactTime: Int
    let price, origQty, executedQty, cummulativeQuoteQty: String
    let status, timeInForce, type, side: String
    let strategyID, strategyType: Int
    let fills: [BinanceOrderFill]
    
    enum CodingKeys: String, CodingKey {
        case symbol
        case orderID = "orderId"
        case orderListID = "orderListId"
        case clientOrderID = "clientOrderId"
        case transactTime, price, origQty, executedQty, cummulativeQuoteQty, status, timeInForce, type, side
        case strategyID = "strategyId"
        case strategyType, fills
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
