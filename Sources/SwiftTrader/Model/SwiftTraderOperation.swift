//
//  SwiftTraderOperation.swift
//  
//
//  Created by Fernando Fernandes on 06.02.22.
//

import Foundation

/// The currently running `SwiftTrader` operation.
public enum SwiftTraderOperation {
    
    // MARK: - FTX
    
    case ftxCancelAllOrders
    case ftxPlaceStopLimitOrder
    case ftxPositions
    case ftxTriggerOrdersList
    
    // MARK: - Kucoin
    
    // MARK: Spot
    
    case kucoinSpotListAccounts
    case kucoinSpotGetAccount
    case kucoinSpotGetTransferable
    
    // MARK: Futures
    
    case kucoinFuturesAccountOverview
    case kucoinFuturesCancelStopOrders
    case kucoinFuturesOrderList
    case kucoinFuturesStopOrderList
    case kucoinFuturesPlaceStopLimitOrder
    case kucoinFuturesPositionList
}
