//
//  NetworkResourceProtocol.swift
//  
//
//  Created by Fernando Fernandes on 28.01.22.
//

import Foundation

/// Represents a typical API resource that can be requested by its `URL`.
///
/// `URL` example: https://api-futures.kucoin.com/api/v1/account-overview?currency=USDT
public protocol NetworkResource {
    var url: URL { get throws }
}
