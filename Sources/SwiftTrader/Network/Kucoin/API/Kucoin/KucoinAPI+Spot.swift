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
            static let accounts  = "/api/v1/accounts"
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
                default:
                    throw SwiftTraderError.invalidOption
                }
            } else {
                // Fallback to production.
                return production
            }
        }
    }
}
