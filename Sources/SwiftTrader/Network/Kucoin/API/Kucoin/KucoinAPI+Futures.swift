//
//  KucoinAPI+Futures.swift
//  
//
//  Created by Fernando Fernandes on 16.07.22.
//

import Foundation

public extension KucoinAPI {
    
    struct Futures {
        
        public struct Path {
            static let accountOverview  = "/api/v1/account-overview"
            static let orders           = "/api/v1/orders"
            static let positions        = "/api/v1/positions"
            static let stopOrders       = "/api/v1/stopOrders"
        }
        
        /// Returns the base `URL` based on an Xcode environment variable.
        ///
        /// In case the above fails/is absent, returns the `production` base `URL`.
        public static func baseURL() throws -> String {
            let production  = "https://api-futures.kucoin.com"
            let sandbox     = "https://api-sandbox-futures.kucoin.com"
            if let environment = Environment.environmentFromXcode() {
                switch environment {
                case .productionFutures:
                    return production
                case .sandboxFutures:
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
