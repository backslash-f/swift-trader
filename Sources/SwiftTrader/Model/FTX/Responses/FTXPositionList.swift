//
//  FTXPositionList.swift
//  
//
//  Created by Fernando Fernandes on 07.03.22.
//

import Foundation

/// FTX "Get Positions" REST API response.
///
/// https://docs.ftx.com/#get-positions
public struct FTXPositionList: Codable {
    public let success: Bool
    public let result: [FTXPosition]
}

// Represents an open position within FTX.
public struct FTXPosition: Codable {
    
    // MARK: - Properties
    
    public let cost: Double
    public let cumulativeBuySize: Double?
    public let cumulativeSellSize: Double?
    public let entryPrice: Double
    public let estimatedLiquidationPrice: Double
    public let future: String
    public let initialMarginRequirement: Double
    public let longOrderSize: Double
    public let maintenanceMarginRequirement: Double
    public let netSize: Double
    public let openSize: Double
    public let realizedPnl: Double
    public let recentAverageOpenPrice: Double?
    public let recentBreakEvenPrice: Double?
    public let recentPnl: Double?
    public let shortOrderSize: Double
    public let side: String
    public let size: Double
    public let unrealizedPnl: Double
    public let collateralUsed: Double
    
    enum CodingKeys: String, CodingKey {
        case cost
        case cumulativeBuySize
        case cumulativeSellSize
        case entryPrice
        case estimatedLiquidationPrice
        case future
        case initialMarginRequirement
        case longOrderSize
        case maintenanceMarginRequirement
        case netSize
        case openSize
        case realizedPnl
        case recentAverageOpenPrice
        case recentBreakEvenPrice
        case recentPnl
        case shortOrderSize
        case side
        case size
        case unrealizedPnl
        case collateralUsed
    }
    
    // MARK: - Lifecycle
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.cost = try container.decode(Double.self, forKey: .cost)
        self.cumulativeBuySize = try container.decodeIfPresent(Double.self, forKey: .cumulativeBuySize)
        self.cumulativeSellSize = try container.decodeIfPresent(Double.self, forKey: .cumulativeSellSize)
        self.entryPrice = try container.decode(Double.self, forKey: .entryPrice)
        self.estimatedLiquidationPrice = try container.decode(Double.self, forKey: .estimatedLiquidationPrice)
        self.future = try container.decode(String.self, forKey: .future)
        self.initialMarginRequirement = try container.decode(Double.self, forKey: .initialMarginRequirement)
        self.longOrderSize = try container.decode(Double.self, forKey: .longOrderSize)
        self.maintenanceMarginRequirement = try container.decode(Double.self, forKey: .maintenanceMarginRequirement)
        self.netSize = try container.decode(Double.self, forKey: .netSize)
        self.openSize = try container.decode(Double.self, forKey: .openSize)
        self.realizedPnl = try container.decode(Double.self, forKey: .realizedPnl)
        self.recentAverageOpenPrice = try container.decodeIfPresent(Double.self, forKey: .recentAverageOpenPrice)
        self.recentBreakEvenPrice = try container.decodeIfPresent(Double.self, forKey: .recentBreakEvenPrice)
        self.recentPnl = try container.decodeIfPresent(Double.self, forKey: .recentPnl)
        self.shortOrderSize = try container.decode(Double.self, forKey: .shortOrderSize)
        self.side = try container.decode(String.self, forKey: .side)
        self.size = try container.decode(Double.self, forKey: .size)
        self.unrealizedPnl = try container.decode(Double.self, forKey: .unrealizedPnl)
        self.collateralUsed = try container.decode(Double.self, forKey: .collateralUsed)
    }
}
