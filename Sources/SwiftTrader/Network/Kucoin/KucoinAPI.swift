//
//  KucoinAPI.swift
//  
//
//  Created by Fernando Fernandes on 29.01.22.
//

import Foundation

/// Holds constants related to  Kucoin REST APIs.
public struct KucoinAPI {
    
    public struct Futures {
        
        public struct Path {
            static let accountOverview  = "/api/v1/account-overview"
            static let orders           = "/api/v1/orders"
            static let positions        = "/api/v1/positions"
        }
        
        /// Returns the base `URL` based on an Xcode environment variable.
        ///
        /// In case the above fails/is absent, returns the `production` base `URL`.
        public static func baseURL() -> String {
            let production = "https://api-futures.kucoin.com"
            let sandbox = "https://api-sandbox-futures.kucoin.com"
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
    
    public struct HeaderField {
        static let apiKey           = "KC-API-KEY"
        static let apiSign          = "KC-API-SIGN"
        static let apiTimestamp     = "KC-API-TIMESTAMP"
        static let apiPassphrase    = "KC-API-PASSPHRASE"
    }
    
    public struct QueryParam {
        static let currency     = "currency"
        static let orderStatus  = "status"
    }
}
