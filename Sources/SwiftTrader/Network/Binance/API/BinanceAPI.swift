//
//  BinanceAPI.swift
//  
//
//  Created by Fernando Fernandes on 03.12.22.
//

import Foundation

/// Holds constants related to  Binance REST APIs.
public struct BinanceAPI {

    public struct HeaderField {
        static let apiKey           = "X-MBX-APIKEY"
    }

    public struct QueryParam {
        public static let side      = "side"
        public static let symbol    = "symbol"
        public static let type      = "type"
    }
}
