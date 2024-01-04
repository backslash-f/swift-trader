//
//  BinanceAuthorizing.swift
//
//
//  Created by Fernando Fernandes on 03.01.24.
//

import Foundation

public protocol BinanceAuthorizing: Codable {
    var apiKey: String { get }
    var apiSecret: String { get }
}
