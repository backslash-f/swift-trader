//
//  KucoinAuth+Futures.swift
//
//
//  Created by Fernando Fernandes on 07.03.24.
//

import Foundation

public extension KucoinAuth {

    struct Futures: KucoinAuthorizing, Codable, Equatable {
        public let apiKey: String
        public let apiSecret: String
        public let apiPassphrase: String

        public init(apiKey: String, apiSecret: String, apiPassphrase: String) {
            self.apiKey = apiKey
            self.apiSecret = apiSecret
            self.apiPassphrase = apiPassphrase
        }

        public static func empty() -> KucoinAuth.Futures {
            KucoinAuth.Futures(apiKey: "", apiSecret: "", apiPassphrase: "")
        }
    }
}
