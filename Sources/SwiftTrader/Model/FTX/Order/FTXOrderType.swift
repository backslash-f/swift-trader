//
//  FTXOrderType.swift
//  
//
//  Created by Fernando Fernandes on 08.03.22.
//

import Foundation

public enum FTXTTriggerOrderType: String, Codable {
    case stop
    case trailingStop
    case takeProfit
}
