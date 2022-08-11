//
//  KucoinSpotGetAccountResponse.swift
//  
//
//  Created by Fernando Fernandes on 11.08.22.
//

import Foundation

/// Kucoin "Get Acount" REST API response.
///
/// https://docs.kucoin.com/#get-an-account
public struct KucoinSpotGetAccountResponse: Codable {
    let code: String
    let data: KucoinSpotAccount
}

/// Encapsulates Kucoin spot account data.
public struct KucoinSpotAccount: Codable {
    let currency, balance: String
    let available, holds: String
}
