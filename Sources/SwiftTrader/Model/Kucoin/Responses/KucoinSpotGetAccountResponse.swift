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
    public let code: String
    public let data: KucoinSpotAccount
}

/// Encapsulates Kucoin spot account data.
public struct KucoinSpotAccount: Codable {
    public let currency, balance: String
    public let available, holds: String
}
