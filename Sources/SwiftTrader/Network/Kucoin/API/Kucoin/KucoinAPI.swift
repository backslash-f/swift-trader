//
//  KucoinAPI.swift
//  
//
//  Created by Fernando Fernandes on 29.01.22.
//

import Foundation

/// Holds constants related to  Kucoin REST APIs.
public struct KucoinAPI {
    
    public struct HeaderField {
        static let apiKey           = "KC-API-KEY"
        static let apiSign          = "KC-API-SIGN"
        static let apiTimestamp     = "KC-API-TIMESTAMP"
        static let apiPassphrase    = "KC-API-PASSPHRASE"
    }
    
    public struct QueryParam {
        public static let currency     = "currency"
        public static let orderStatus  = "status"
        public static let symbol       = "symbol"
    }
}
