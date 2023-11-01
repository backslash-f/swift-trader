//
//  BinanceAPI+Spot.swift
//  
//
//  Created by Fernando Fernandes on 03.12.22.
//

import Foundation

public extension BinanceAPI {

    struct Spot {

        public struct Path {
            static let newOrder = "/api/v3/order"
        }

        /// Returns the base `URL` based on an Xcode environment variable.
        ///
        /// In case the above fails/is absent, returns the `production` base `URL`.
        public static func baseURL() throws -> String {
            let production  = "https://api.binance.com/api"
            let sandbox     = "https://testnet.binance.vision/api"
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
