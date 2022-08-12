//
//  KucoinSpotOrderList.swift
//  
//
//  Created by Fernando Fernandes on 12.08.22.
//

import Foundation

/// Kucoin "List Orders" REST API response.
///
/// https://docs.kucoin.com/#list-orders
public struct KucoinSpotOrderListResponse: Codable {
    public let code: String
    public let data: KucoinSpotOrderData
}

/// Encapsulates an array of `KucoinSpotOrder` plus pagination information.
public struct KucoinSpotOrderData: Codable {
    public let currentPage: Int
    public let pageSize: Int
    public let totalNum: Int
    public let totalPage: Int
    public let items: [KucoinSpotOrder]
}

public struct KucoinSpotOrder: Codable {
    let id, symbol, opType, type: String
    let side, size, funds: String
    let dealFunds, dealSize, fee, feeCurrency: String
    let stopTriggered: Bool
    let timeInForce: String
    let postOnly, hidden, iceberg: Bool
    let visibleSize: String
    let cancelAfter: Int
    let channel: String
    let isActive, cancelExist: Bool
    let createdAt: Int
    let tradeType: String
    let remark, price, stp, stop, stopPrice, clientOID, tags: String?

    enum CodingKeys: String, CodingKey {
        case id, symbol, opType, type, side, price, size, funds, dealFunds, dealSize, fee, feeCurrency, stp, stop, stopTriggered, stopPrice, timeInForce, postOnly, hidden, iceberg, visibleSize, cancelAfter, channel
        case clientOID = "clientOid"
        case remark, tags, isActive, cancelExist, createdAt, tradeType
    }
}
