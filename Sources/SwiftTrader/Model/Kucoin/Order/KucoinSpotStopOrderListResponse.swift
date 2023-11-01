//
//  KucoinSpotStopOrderListResponse.swift
//  
//
//  Created by Fernando Fernandes on 12.08.22.
//

import Foundation

/// Kucoin "List Stop Orders" REST API response.
///
/// https://docs.kucoin.com/#list-stop-orders
public struct KucoinSpotStopOrderListResponse: Codable {
    public let code: String
    public let data: KucoinSpotStopOrderData
}

/// Encapsulates an array of `KucoinSpotStopOrder` plus pagination information.
public struct KucoinSpotStopOrderData: Codable {
    public let currentPage, pageSize, totalNum, totalPage: Int
    public let items: [KucoinSpotStopOrder]
}

public struct KucoinSpotStopOrder: Codable {
    let id, symbol, userID, status: String
    let type, side, price, size: String
    let timeInForce: String
    let cancelAfter: Int
    let postOnly, hidden, iceberg: Bool
    let channel, clientOID: String
    let orderTime: Double
    let domainID, tradeSource, tradeType, feeCurrency: String
    let takerFeeRate, makerFeeRate: String
    let createdAt: Int
    let stop: String
    let stopPrice: String

    let funds, stp, visibleSize, remark, tags, stopTriggerTime: String?

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case clientOID = "clientOid"
        case domainID = "domainId"
        case id, symbol, status, type, side, price, size, funds, stp, timeInForce, cancelAfter, postOnly, hidden
        case iceberg, visibleSize, channel, remark, tags, orderTime, tradeSource, tradeType, feeCurrency, takerFeeRate
        case makerFeeRate, createdAt, stop, stopTriggerTime, stopPrice
    }
}
