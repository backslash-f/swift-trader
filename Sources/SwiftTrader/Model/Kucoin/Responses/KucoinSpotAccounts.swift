//
//  KucoinAccounts.swift
//  
//
//  Created by Fernando Fernandes on 16.07.22.
//

import Foundation

/// Kucoin "List Acounts" REST API response.
///
/// https://docs.kucoin.com/#list-accounts
public struct KucoinSpotListAccounts: Codable {
    let code: String
    let data: [KucoinFuturesAccount]
}

/// Encapsulates Kucoin futures account data.
public struct KucoinFuturesAccount: Codable {
    let id, currency, balance: String
    let type: KucoinAccountType
    let available, holds: String
}

/// Kucoin "Get Acount" REST API response.
///
/// https://docs.kucoin.com/#get-an-account
public struct KucoinSpotGetAccount: Codable {
    let code: String
    let data: KucoinSpotAccount
}

/// Encapsulates Kucoin spot account data.
public struct KucoinSpotAccount: Codable {
    let currency, balance: String
    let available, holds: String
}

/// There are three types of accounts: 1) main account 2) trade account 3) margin account.
public enum KucoinAccountType: String, Codable {
    case main
    case trade
    case margin
}
