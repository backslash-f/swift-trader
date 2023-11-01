//
//  KucoinFuturesPositionList.swift
//  
//
//  Created by Fernando Fernandes on 06.02.22.
//

import Foundation

/// Kucoin "Get Position List" REST API response.
///
/// https://docs.kucoin.com/futures/#get-position-list
public struct KucoinFuturesPositionList: Codable {
    public let code: String
    public let data: [KucoinFuturesPosition]
}

public struct KucoinFuturesPosition: Codable {

    // MARK: - Properties

    public let id: String

    /// E.g.: XBTUSDTM
    public let symbol: String
    public let autoDeposit: Bool
    public let realLeverage: Double
    public let crossMode: Bool
    public let delevPercentage: Double

    /// Opening date in milliseconds.
    public let openingTimestamp: Int64
    /// Opening date as string (E.g.: "Saturday, 5. February 2022 at 22:32:16").
    public let openingTimestampString: String

    /// Current date in milliseconds.
    public let currentTimestamp: Int64
    /// Current date as string (E.g.: "Saturday, 5. February 2022 at 22:32:16").
    public let currentTimestampString: String

    public let posInit: Double
    public let currentQty: Int
    public let isOpen: Bool
    public let markPrice: Double
    public let realisedPnl: Double
    public let unrealisedPnl: Double
    public let avgEntryPrice: Double
    public let liquidationPrice: Double

    enum CodingKeys: String, CodingKey {
        case id
        case symbol
        case autoDeposit
        case realLeverage
        case crossMode
        case delevPercentage
        case openingTimestamp
        case openingTimestampString
        case currentTimestamp
        case currentTimestampString
        case posInit
        case currentQty
        case isOpen
        case markPrice
        case realisedPnl
        case unrealisedPnl
        case avgEntryPrice
        case liquidationPrice
    }

    // MARK: - Lifecycle

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.symbol = try container.decode(String.self, forKey: .symbol)
        self.autoDeposit = try container.decode(Bool.self, forKey: .autoDeposit)
        self.realLeverage = try container.decode(Double.self, forKey: .realLeverage)
        self.crossMode = try container.decode(Bool.self, forKey: .crossMode)
        self.delevPercentage = try container.decode(Double.self, forKey: .delevPercentage)

        self.openingTimestamp = try container.decode(Int64.self, forKey: .openingTimestamp)
        self.openingTimestampString = Date(milliseconds: self.openingTimestamp).toString()

        self.currentTimestamp = try container.decode(Int64.self, forKey: .currentTimestamp)
        self.currentTimestampString = Date(milliseconds: self.currentTimestamp).toString()

        self.posInit = try container.decode(Double.self, forKey: .posInit)
        self.currentQty = try container.decode(Int.self, forKey: .currentQty)
        self.isOpen = try container.decode(Bool.self, forKey: .isOpen)
        self.markPrice = try container.decode(Double.self, forKey: .markPrice)
        self.realisedPnl = try container.decode(Double.self, forKey: .realisedPnl)
        self.unrealisedPnl = try container.decode(Double.self, forKey: .unrealisedPnl)
        self.avgEntryPrice = try container.decode(Double.self, forKey: .avgEntryPrice)
        self.liquidationPrice = try container.decode(Double.self, forKey: .liquidationPrice)
    }
}
