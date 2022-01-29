//
//  KucoinAuthentication.swift
//  
//
//  Created by Fernando Fernandes on 29.01.22.
//

import Foundation

/// Holds data required to authenticate the requests against Kucoin APIs.
public struct KucoinAuth {
    public let apiKey: String
    public let apiSecret: String
    public let apiPassphrase: String
}
