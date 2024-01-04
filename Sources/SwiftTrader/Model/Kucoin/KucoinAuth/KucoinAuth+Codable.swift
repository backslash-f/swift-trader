//
//  KucoinAuth+Codable.swift
//
//
//  Created by Fernando Fernandes on 03.01.24.
//

import Foundation

extension KucoinAuth: Codable {
    public enum CodingKeys: String, CodingKey {
        case spot
        case futures
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.spot = try container.decode(Spot.self, forKey: .spot)
        self.futures = try container.decode(Futures.self, forKey: .futures)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        let redactedSpot = Spot(
            apiKey: spot.apiKey.masked(),
            apiSecret: spot.apiSecret.masked(),
            apiPassphrase: spot.apiPassphrase.masked()
        )
        let redactedFutures = Futures(
            apiKey: futures.apiKey.masked(),
            apiSecret: futures.apiSecret.masked(),
            apiPassphrase: futures.apiPassphrase.masked()
        )
        try container.encode(redactedSpot, forKey: .spot)
        try container.encode(redactedFutures, forKey: .futures)
    }
}
