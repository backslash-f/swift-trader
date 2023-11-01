//
//  KucoinCancelledStopOrders.swift
//  
//
//  Created by Fernando Fernandes on 16.02.22.
//

import Foundation

/// Holds a list of cancelled orders.
public struct KucoinCancelledStopOrders: Codable {

    public let cancelledOrderIDs: [String]

    enum CodingKeys: String, CodingKey {
        case cancelledOrderIDs = "cancelledOrderIds"
    }
}
