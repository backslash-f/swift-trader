//
//  BinanceAuth+RawRepresentable.swift
//
//
//  Created by Fernando Fernandes on 11.03.24.
//

import Foundation

extension BinanceAuth: RawRepresentable {
    public typealias RawValue = String

    public init?(rawValue: RawValue) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode(BinanceAuth.self, from: data) else {
            return nil
        }
        self = result
    }

    public var rawValue: RawValue {
        guard let data = try? JSONEncoder().encode(self) else {
            return "Failed to encode data"
        }
        guard let jsonString = String(data: data, encoding: .utf8) else {
            return "Faile to convert data to String"
        }
        return jsonString
    }
}
