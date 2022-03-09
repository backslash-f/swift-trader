//
//  FTXPlaceTriggerOrder.swift
//  
//
//  Created by Fernando Fernandes on 08.03.22.
//

import Foundation

/// FTX "Place Trigger Order" REST API response.
///
/// https://docs.ftx.com/?python#place-trigger-order
public struct FTXPlaceTriggerOrder: Codable {
    public let success: Bool
    public let result: FTXOrder
}
