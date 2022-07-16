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
public struct KucoinAccounts: Codable {
    let code: String
    let data: [KucoinAccount]
}

/// Encapsulates Kucoin account data.
public struct KucoinAccount: Codable {
    let id, currency, balance: String
    let type: KucoinAccountType
    let available, holds: String
}

/// There are three types of accounts: 1) main account 2) trade account 3) margin account.
public enum KucoinAccountType: String, Codable {
    case main
    case trade
    case margin
}
