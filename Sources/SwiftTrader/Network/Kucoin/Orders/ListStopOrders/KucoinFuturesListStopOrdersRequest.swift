//
//  KucoinFuturesListStopOrdersRequest.swift
//  
//
//  Created by Fernando Fernandes on 02.03.22.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import Logging

/// A **request** for listing all untriggered stop orders of a given (contract) symbol.
///
/// https://docs.kucoin.com/futures/#get-untriggered-stop-order-list
public struct KucoinFuturesListStopOrdersRequest: NetworkRequest {
    
    // MARK: - Properties
    
    public typealias DecodableModel = KucoinFuturesOrderList
    
    public var logger: Logger {
        NetworkRequestLogger().default
    }
    
    public var session: URLSession
    
    public var request: URLRequest {
        get throws {
            let futuresListOrdersResource = KucoinFuturesListStopOrdersResource(symbol: symbol)
            var urlRequest = URLRequest(url: try futuresListOrdersResource.url)
            urlRequest.httpMethod = HTTPMethod.GET.rawValue
            try KucoinAPI.setRequestHeaderFields(request: &urlRequest, kucoinAuth: kucoinAuth.futures)
            return urlRequest
        }
    }
    
    public var settings: NetworkRequestSettings
    
    // MARK: Private
    
    private let symbol: String
    
    private let kucoinAuth: KucoinAuth
    
    // MARK: - Lifecycle
    
    /// Creates a new `KucoinFuturesListStopOrdersRequest` instance.
    ///
    /// - Parameters:
    ///   - symbol: `String`, represents the specific contract for which all the untriggered stop orders will be listed.
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

public extension KucoinFuturesListStopOrdersRequest {
    
    func decode(_ data: Data) throws -> DecodableModel {
        try JSONDecoder().decode(KucoinFuturesOrderList.self, from: data)
    }
}
