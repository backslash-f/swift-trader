//
//  SwiftTraderOperation.swift
//  
//
//  Created by Fernando Fernandes on 06.02.22.
//

import Foundation

/// The currently running `SwiftTrader` operation.
public enum SwiftTraderOperation {
    
    // MARK: - Binance
    
    case binanceSpotNewOrder
    
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
    case kucoinSpotPlaceStopLimitOrder
    case kucoinSpotOrderList
    case kucoinSpotStopOrderList
    case kucoinSpotCancelStopOrders
    
    // MARK: Futures
    
    case kucoinFuturesAccountOverview
    case kucoinFuturesCancelStopOrders
    case kucoinFuturesOrderList
    case kucoinFuturesStopOrderList
    case kucoinFuturesPlaceStopLimitOrder
    case kucoinFuturesPositionList
}
