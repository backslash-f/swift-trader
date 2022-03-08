//
//  FTXPlaceTriggerOrder.swift
//  
//
//  Created by Fernando Fernandes on 08.03.22.
//

import Foundation

/// FTX "Place Trigger Order" REST API response.
///
/// https://docs.ftx.com/?python#place-trigger-order
public struct FTXPlaceTriggerOrder: Codable {
    
    // MARK: - Properties
    
    public let success: Bool
    public let result: FTXOrder
    
    enum CodingKeys: String, CodingKey {
        case success
        case result
    }
}

// Represents an order that was placed within FTX.
public struct FTXOrder: Codable {
    
    // MARK: - Properties
    
    public let createdAt: String
    public let future: String
    public let id: Int
    public let market: String
    public let triggerPrice: Double
    public let side: String
    public let size: Double
    public let status: String
    public let type: String
    public let orderPrice: String?
    public let error: String?
    public let triggeredAt: String?
    public let reduceOnly: Bool
    public let orderType: String
    public let retryUntilFilled: Bool
    
    enum CodingKeys: String, CodingKey {
        case createdAt
        case future
        case id
        case market
        case triggerPrice
        case side
        case size
        case status
        case type
        case orderPrice
        case error
        case triggeredAt
        case reduceOnly
        case orderType
        case retryUntilFilled
    }
    
    // MARK: - Lifecycle
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.createdAt = try container.decode(String.self, forKey: .createdAt)
        self.future = try container.decode(String.self, forKey: .future)
        self.id = try container.decode(Int.self, forKey: .id)
        self.market = try container.decode(String.self, forKey: .market)
        self.triggerPrice = try container.decode(Double.self, forKey: .triggerPrice)
        self.side = try container.decode(String.self, forKey: .side)
        self.size = try container.decode(Double.self, forKey: .size)
        self.status = try container.decode(String.self, forKey: .status)
        self.type = try container.decode(String.self, forKey: .type)
        self.orderPrice = try container.decodeIfPresent(String.self, forKey: .orderPrice)
        self.error = try container.decodeIfPresent(String.self, forKey: .error)
        self.triggeredAt = try container.decodeIfPresent(String.self, forKey: .triggeredAt)
        self.reduceOnly = try container.decode(Bool.self, forKey: .reduceOnly)
        self.orderType = try container.decode(String.self, forKey: .orderType)
        self.retryUntilFilled = try container.decode(Bool.self, forKey: .retryUntilFilled)
    }
}
