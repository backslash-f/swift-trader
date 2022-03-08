//
//  FTXAPI.swift
//  
//
//  Created by Fernando Fernandes on 07.03.22.
//

import Foundation

/// Holds constants related to  FTX REST APIs.
public struct FTXAPI {
    
    public struct BaseURL {
        static let production = "https://ftx.com"
    }
    
    public struct HeaderField {
        static let apiKey           = "FTX-KEY"
        static let apiSign          = "FTX-SIGN"
        static let apiTimestamp     = "FTX-TS"
    }
    
    public struct Path {
        static let positions  = "/api/positions"
    }
}
