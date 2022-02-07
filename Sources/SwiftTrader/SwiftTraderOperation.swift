//
//  SwiftTraderOperation.swift
//  
//
//  Created by Fernando Fernandes on 06.02.22.
//

import Foundation

/// The currently running `SwiftTrader` operation.
public enum SwiftTraderOperation {
    case kucoinFuturesAccountOverview
    case kucoinFuturesOrderList
    case kucoinFuturesPlaceOrder
    case kucoinFuturesPositionList
}
