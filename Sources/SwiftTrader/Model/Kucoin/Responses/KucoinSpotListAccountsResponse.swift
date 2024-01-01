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
public struct KucoinSpotListAccountsResponse: Codable {
    public let code: String
    public let data: [KucoinAccount]
}

/// Encapsulates Kucoin  accounts data.
public struct KucoinAccount: Codable {
    public let id, currency, balance: String
    public let type: KucoinAccountType
    public let available, holds: String
}

/// There are three types of accounts: 1) main account 2) trade account 3) margin account.
public enum KucoinAccountType: String, Codable {
    case main
    case trade
    case margin
}
