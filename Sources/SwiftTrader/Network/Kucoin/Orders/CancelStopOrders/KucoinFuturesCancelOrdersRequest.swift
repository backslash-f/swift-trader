//
//  KucoinFuturesCancelOrdersRequest.swift
//  
//
//  Created by Fernando Fernandes on 16.02.22.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import Logging

/// A **request** for cancelling all untriggered stop orders of a given symbol (contract).
///
/// https://docs.kucoin.com/futures/#stop-order-mass-cancelation
public struct KucoinFuturesCancelOrdersRequest: NetworkRequest {
    
    // MARK: - Properties
    
    public typealias DecodableModel = KucoinFuturesCancelStopOrders
    
    public var logger: Logger {
        NetworkRequestLogger().default
    }
    
    public var session: URLSession
    
    public var request: URLRequest {
        get throws {
            let futuresCancelOrdersResource = KucoinFuturesCancelOrdersResource(symbol: symbol)
            var urlRequest = URLRequest(url: try futuresCancelOrdersResource.url)
            urlRequest.httpMethod = HTTPMethod.DELETE.rawValue
            try KucoinAPI.setRequestHeaderFields(request: &urlRequest, kucoinAuth: kucoinAuth)
            return urlRequest
        }
    }
    
    public var settings: NetworkRequestSettings
    
    // MARK: Private
    
    private let symbol: String
    
    private let kucoinAuth: KucoinAuth
    
    // MARK: - Lifecycle
    
    /// Creates a new `KucoinFuturesOrdersListRequest` instance.
    ///
    /// - Parameters:
    ///   - symbol: `String`, represents the specific contract for which all the untriggered stop orders will be cancelled.
    ///   E.g.: "XBTUSDM".
    ///   - kucoinAuth: Kucoin authentication data.
    ///   - session: `URLSession`, default is `.shared`.
    ///   - settings: `NetworkRequestSettings`.
    public init(symbol: String,
                kucoinAuth: KucoinAuth,
                session: URLSession = .shared,
                settings: NetworkRequestSettings) {
        self.symbol = symbol
        self.kucoinAuth = kucoinAuth
        self.session = session
        self.settings = settings
    }
}

// MARK: - Network Request Protocol

public extension KucoinFuturesCancelOrdersRequest {
    
    func decode(_ data: Data) throws -> DecodableModel {
        try JSONDecoder().decode(KucoinFuturesCancelStopOrders.self, from: data)
    }
}
