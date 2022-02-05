//
//  KucoinFuturesOrderList.swift
//  
//
//  Created by Fernando Fernandes on 04.02.22.
//

import Foundation

/// Kucoin "Get Order List" REST API response.
///
/// https://docs.kucoin.com/futures/#get-order-list
public struct KucoinFuturesOrderList: Codable {
    public let code: String
    public let data: KucoinFuturesOrderData
}

/// Encapsulates an array of `KucoinFuturesOrder` plus pagination information.
public struct KucoinFuturesOrderData: Codable {
    let currentPage: Int
    let pageSize: Int
    let totalNum: Int
    let totalPage: Int
    let items: [KucoinFuturesOrder]
}

public struct KucoinFuturesOrder: Codable {
    
    // MARK: - Properties
    
    let id: String
    
    /// E.g.: BTCUSDT
    let symbol: String
    
    let type: KucoinOrderType
    let side: KucoinOrderSide
    
    /// The price of one asset's unit.
    let price: String
    
    /// How much assets were bought.
    let size: Int
    
    /// The total value of the order.
    let value: String
    let filledValue: String
    let filledSize: Int
    let stp: KucoinOrderSTP?
    
    /// Stop order type (limit or market).
    let stop: KucoinOrderType?
    
    /// Whether the stop order is triggered.
    let stopTriggered: Bool
    
    /// Whether the stop order is triggered.
    let stopPrice: String?
    let leverage: String
    let reduceOnly: Bool
    
    /// Unique order id created by users to identify their orders.
    let clientOid: String?
    let isActive: Bool
    
    /// Mark of the canceled orders.
    let cancelExist: Bool
    let status: KucoinOrderStatus
    let createdAt: String
    
    /// Last update time.
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case symbol
        case type
        case side
        case price
        case size
        case value
        case filledValue
        case filledSize
        case stp
        case stop
        case stopTriggered
        case stopPrice
        case leverage
        case reduceOnly
        case clientOid
        case isActive
        case cancelExist
        case createdAt
        case status
        case updatedAt
    }
    
    // MARK: - Lifecycle
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(String.self, forKey: .id)
        self.symbol = try container.decode(String.self, forKey: .symbol)
        self.type = try container.decode(KucoinOrderType.self, forKey: .type)
        self.side = try container.decode(KucoinOrderSide.self, forKey: .side)
        self.price = try container.decode(String.self, forKey: .price)
        self.size = try container.decode(Int.self, forKey: .size)
        self.value = try container.decode(String.self, forKey: .value)
        self.filledValue = try container.decode(String.self, forKey: .filledValue)
        self.filledSize = try container.decode(Int.self, forKey: .filledSize)
        
        let decodedSTP = try container.decode(String.self, forKey: .stp)
        if !decodedSTP.isEmpty,
           let orderSTP = KucoinOrderSTP(rawValue: decodedSTP) {
            self.stp = orderSTP
        } else {
            self.stp = nil
        }
        
        let decodedStop = try container.decode(String.self, forKey: .stop)
        if !decodedStop.isEmpty,
           let stopType = KucoinOrderType(rawValue: decodedStop) {
            self.stop = stopType
        } else {
            self.stop = nil
        }
        
        self.stopTriggered = try container.decode(Bool.self, forKey: .stopTriggered)
        self.stopPrice = try container.decodeIfPresent(String.self, forKey: .stopPrice)
        self.leverage = try container.decode(String.self, forKey: .leverage)
        self.reduceOnly = try container.decode(Bool.self, forKey: .reduceOnly)
        self.clientOid = try container.decodeIfPresent(String.self, forKey: .clientOid)
        self.isActive = try container.decode(Bool.self, forKey: .isActive)
        self.cancelExist = try container.decode(Bool.self, forKey: .cancelExist)
        self.status = try container.decode(KucoinOrderStatus.self, forKey: .status)
        
        let createdAtMilliseconds = try container.decode(Int64.self, forKey: .createdAt)
        self.createdAt = Date(milliseconds: createdAtMilliseconds).toString()
    
        let updatedAtMilliseconds = try container.decode(Int64.self, forKey: .updatedAt)
        self.updatedAt = Date(milliseconds: updatedAtMilliseconds).toString()
    }
}
