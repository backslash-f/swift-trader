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
        let spot = Spot(
            apiKey: spot.apiKey,
            apiSecret: spot.apiSecret,
            apiPassphrase: spot.apiPassphrase
        )
        let futures = Futures(
            apiKey: futures.apiKey,
            apiSecret: futures.apiSecret,
            apiPassphrase: futures.apiPassphrase
        )
        try container.encode(spot, forKey: .spot)
        try container.encode(futures, forKey: .futures)
    }
}
