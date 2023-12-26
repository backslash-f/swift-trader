//
//  KucoinAPI+Spot.swift
//
//
//  Created by Fernando Fernandes on 16.07.22.
//

import Foundation

public extension KucoinAPI {

    struct Spot {

        public struct Path {
            static let bulletPrivate    = "/api/v1/bullet-private"
            static let orders           = "/api/v1/orders"
            static let stopOrder        = "/api/v1/stop-order"
            static let stopOrderCancel  = "/api/v1/stop-order/cancel"
            static let transferable     = accounts(pathComponent: "transferable")

            /// Returns the path for getting accounts within Kucoin spot.
            ///
            /// `pathComponent` required as `URL.appendingPathComponent(_:)` will be deprecated and
            /// `URL.appending(path:directoryHint:)` is only available in macOS 13 and later (so not in Linux / Heroku).
            ///
            /// - Parameter pathComponent: use this parameter to append extra info to the returned
            /// `String`, e.g.: "/api/v1/accounts/5bd6e9286d99522a52e458de"
            /// - Returns: `/api/v1/accounts` or `/api/v1/accounts/pathComponent`
            static func accounts(pathComponent: String? = nil) -> String {
                if let path = pathComponent {
                    return "/api/v1/accounts" + "/" + path
                } else {
                    return "/api/v1/accounts"
                }
            }
        }

        /// Returns the base `URL` based on an Xcode environment variable.
        ///
        /// In case the above fails/is absent, returns the `production` base `URL`.
        public static func baseURL() throws -> String {
            let production  = "https://api.kucoin.com"
            let sandbox     = "https://openapi-sandbox.kucoin.com"
            if let environment = Environment.environmentFromXcode() {
                switch environment {
                case .production:
                    return production
                case .sandbox:
                    return sandbox
                }
            } else {
                // Fallback to production.
                return production
            }
        }
    }
}
