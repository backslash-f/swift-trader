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

    // MARK: - Kucoin

    // MARK: Spot

    case kucoinSpotListAccounts
    case kucoinSpotGetAccount
    case kucoinSpotGetTransferable
    case kucoinSpotPlaceStopLimitOrder
    case kucoinSpotOrderList
    case kucoinSpotStopOrderList
    case kucoinSpotCancelStopOrders
    case kucoinSpotWebSocketPrivateToken

    // MARK: Spot HF

    case kucoinSpotHFPlaceMultipleBuyLimitOrders

    // MARK: Futures

    case kucoinFuturesAccountOverview
    case kucoinFuturesCancelStopOrders
    case kucoinFuturesOrderList
    case kucoinFuturesStopOrderList
    case kucoinFuturesPlaceStopLimitOrder
    case kucoinFuturesPositionList
}
