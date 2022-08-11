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
    let code: String
    let data: KucoinSpotTransferable
}

/// Encapsulates Kucoin spot account data.
public struct KucoinSpotTransferable: Codable {
    let currency, balance, available, holds, transferable: String
}
