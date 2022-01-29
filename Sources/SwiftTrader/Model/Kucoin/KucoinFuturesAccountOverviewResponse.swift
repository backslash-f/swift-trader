//
//  KucoinFuturesAccountOverviewResponse.swift
//  
//
//  Created by Fernando Fernandes on 27.01.22.
//

import Foundation

/// Kucoin "Get Account Overview" REST API response.
///
/// https://docs.kucoin.com/futures/#account
public struct KucoinFuturesAccountOverviewResponse: Codable {
    public let code: String
    public let data: KucoinFuturesAccountData
}

/// Provides an overview of a Kucoin Futures account.
/// 
/// https://docs.kucoin.com/futures/#account
public struct KucoinFuturesAccountData: Codable {
    /// Account equity = marginBalance + Unrealised PNL.
    public let accountEquity: Double
    
    public let availableBalance: Double
    
    /// Currency code, e.g.: "XBT", "USDT".
    public let currency: String
    
    /// Frozen funds for withdrawal and out-transfer.
    public let frozenFunds: Double
    
    /// Margin balance = positionMargin + orderMargin + frozenFunds + availableBalance - unrealisedPNL
    public let marginBalance: Double
    
    public let orderMargin: Double
    
    public let positionMargin: Double
    
    /// Unrealised profit and loss.
    public let unrealisedPNL: Double
}
