//
//  KucoinSpotGetTransferableResponse.swift
//  
//
//  Created by Fernando Fernandes on 11.08.22.
//

import Foundation

/// Kucoin "Get Transferable" REST API response.
///
/// https://docs.kucoin.com/#get-the-transferable
public struct KucoinSpotGetTransferableResponse: Codable {
    public let code: String
    public let data: KucoinSpotTransferable
}

/// Encapsulates Kucoin spot account data.
public struct KucoinSpotTransferable: Codable {
    public let currency, balance, available, holds, transferable: String
}
