//
//  KucoinError.swift
//  
//
//  Created by Fernando Fernandes on 28.01.22.
//

import Foundation

/// Represents errors that may occur while interacting with Kucoin REST APIs.
///
/// https://docs.kucoin.com/futures/#requests
public struct KucoinSystemError: Codable {
    public let code: String
    public let message: String
    
    public enum CodingKeys: String, CodingKey {
        case code
        case message = "msg"
    }
}
