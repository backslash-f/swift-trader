//
//  FTXTriggerOrders.swift
//  
//
//  Created by Fernando Fernandes on 09.03.22.
//

import Foundation

/// FTX "Place Trigger Order" REST API response.
///
/// https://docs.ftx.com/?python#get-open-trigger-orders
public struct FTXTriggerOrders: Codable {
    public let success: Bool
    public let result: [FTXOrder]
}
