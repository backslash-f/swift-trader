//
//  KucoinError.swift
//  
//
//  Created by Fernando Fernandes on 28.01.22.
//

import Foundation

/// Encapsulates Kucoin system errors that may occur while interacting with its REST APIs.
///
/// https://docs.kucoin.com/futures/#requests
public struct KucoinSystemError: Codable {
    public let code: String
    public let message: String
    
    enum CodingKeys: String, CodingKey {
        case code
        case message = "msg"
    }
}
