//
//  BinanceAuth+Codable.swift
//
//
//  Created by Fernando Fernandes on 03.01.24.
//

import Foundation

extension BinanceAuth: Codable {
    public enum CodingKeys: String, CodingKey {
        case spot
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.spot = try container.decode(Spot.self, forKey: .spot)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        let spot = Spot(
            apiKey: spot.apiKey,
            apiSecret: spot.apiSecret
        )
        try container.encode(spot, forKey: .spot)
    }
}
