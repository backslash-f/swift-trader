//
//  BinanceError.swift
//  
//
//  Created by Fernando Fernandes on 04.12.22.
//

import Foundation

/// Encapsulates Binance  errors that may occur while interacting with its REST APIs.
public struct BinanceError: Codable {
    public let code: Int
    public let message: String

    enum CodingKeys: String, CodingKey {
        case code
        case message = "msg"
    }
}
