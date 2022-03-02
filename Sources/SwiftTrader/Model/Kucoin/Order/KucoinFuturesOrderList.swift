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
    public let currentPage: Int
    public let pageSize: Int
    public let totalNum: Int
    public let totalPage: Int
    public let items: [KucoinFuturesOrder]
}

public struct KucoinFuturesOrder: Codable {
    
    // MARK: - Properties
    
    public let id: String
    
    /// E.g.: BTCUSDT
    public let symbol: String
    
    public let type: KucoinOrderType
    public let side: KucoinOrderSide
    
    /// The price of one asset's unit.
    public let price: String
    
    /// How much assets were bought.
    public let size: Int
    
    /// The total value of the order.
    public let value: String
    public let filledValue: String
    public let filledSize: Int
    public let stp: KucoinOrderSTP?
    
    /// Stop order type (limit or market).
    public let stop: KucoinOrderType?
    
    /// Whether the stop order is triggered.
    public let stopTriggered: Bool
    
    /// Whether the stop order is triggered.
    public let stopPrice: String?
    public let leverage: String
    public let reduceOnly: Bool
    
    /// Unique order id created by users to identify their orders.
    public let clientOid: String?
    public let isActive: Bool
    
    /// Mark of the canceled orders.
    public let cancelExist: Bool
    public let status: KucoinOrderStatus
    
    /// Creation date in milliseconds.
    public let createdAt: Int64
    /// Creation date as string (E.g.: "Saturday, 5. February 2022 at 22:32:16").
    public let createdAtString: String
    
    /// Last update time in milliseconds.
    public let updatedAt: Int64
    /// Last update time as string (E.g.: "Saturday, 5. February 2022 at 22:32:16")
    public let updatedAtString: String
    
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
        case status
        case createdAt
        case createdAtString
        case updatedAt
        case updatedAtString
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
        
        self.stopTriggered = try container.decodeIfPresent(Bool.self, forKey: .stopTriggered) ?? false
        self.stopPrice = try container.decodeIfPresent(String.self, forKey: .stopPrice)
        self.leverage = try container.decode(String.self, forKey: .leverage)
        self.reduceOnly = try container.decode(Bool.self, forKey: .reduceOnly)
        self.clientOid = try container.decodeIfPresent(String.self, forKey: .clientOid)
        self.isActive = try container.decode(Bool.self, forKey: .isActive)
        self.cancelExist = try container.decode(Bool.self, forKey: .cancelExist)
        self.status = try container.decode(KucoinOrderStatus.self, forKey: .status)
        
        self.createdAt = try container.decode(Int64.self, forKey: .createdAt)
        self.createdAtString = Date(milliseconds: self.createdAt).toString()
    
        self.updatedAt = try container.decode(Int64.self, forKey: .updatedAt)
        self.updatedAtString = Date(milliseconds: self.updatedAt).toString()
    }
}
