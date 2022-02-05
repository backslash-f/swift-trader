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
            static let accountOverview = "/api/v1/account-overview"
            static let orderList = "/api/v1/orders"
        }
        
        public struct URL {
            static let base = "https://api-futures.kucoin.com"
            static let sandbox = "https://api-sandbox-futures.kucoin.com"
        }
    }
    
    public struct HeaderField {
        static let apiKey           = "KC-API-KEY"
        static let apiSign          = "KC-API-SIGN"
        static let apiTimestamp     = "KC-API-TIMESTAMP"
        static let apiPassphrase    = "KC-API-PASSPHRASE"
    }
    
    public struct QueryParam {
        static let currency = "currency"
        static let orderStatus = "status"
    }
}
