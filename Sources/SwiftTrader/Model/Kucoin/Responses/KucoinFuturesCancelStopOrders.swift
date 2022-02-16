//
//  KucoinFuturesCancelStopOrders.swift
//  
//
//  Created by Fernando Fernandes on 16.02.22.
//

import Foundation

/// Kucoin "Stop Order Mass cancelation" REST API response.
///
/// https://docs.kucoin.com/futures/#stop-order-mass-cancelation
public struct KucoinFuturesCancelStopOrders: Codable {
    public let code: String
    public let data: KucoinCancelledStopOrders
}
