//
//  FTXCancelOrder.swift
//  
//
//  Created by Fernando Fernandes on 09.03.22.
//

import Foundation

/// Encapsulates FTX  responses for calls such ass "Cancel all Orders".
///
/// https://docs.ftx.com/?python#cancel-all-orders
public struct FTXCancelOrder: Codable {
    public let isSuccess: Bool
    public let result: String
    
    enum CodingKeys: String, CodingKey {
        case isSuccess = "success"
        case result = "result"
    }
}
