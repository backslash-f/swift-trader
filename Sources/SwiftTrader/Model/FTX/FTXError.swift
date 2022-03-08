//
//  FTXError.swift
//  
//
//  Created by Fernando Fernandes on 08.03.22.
//

import Foundation

/// Encapsulates FTX  errors that may occur while interacting with its REST APIs.
public struct FTXError: Codable {
    public let isSuccess: Bool
    public let errorMessage: String
    
    enum CodingKeys: String, CodingKey {
        case isSuccess = "success"
        case errorMessage = "error"
    }
}
