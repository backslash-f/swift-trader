//
//  FTXListTriggerOrdersRequest.swift
//  
//
//  Created by Fernando Fernandes on 09.03.22.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import Logging

/// A **request** for listing all open trigger orders of a given (contract) symbol.
///
/// https://docs.ftx.com/?python#get-open-trigger-orders
public struct FTXListTriggerOrdersRequest: NetworkRequest {
    
    // MARK: - Properties
    
    public typealias DecodableModel = FTXTriggerOrders
    
    public var logger: Logger {
        NetworkRequestLogger().default
    }
    
    public var session: URLSession
    
    public var request: URLRequest {
        get throws {
            let listTriggerOrdersResource = FTXListTriggerOrdersResource(market: market)
            var urlRequest = URLRequest(url: try listTriggerOrdersResource.url)
            urlRequest.httpMethod = HTTPMethod.GET.rawValue
            try FTXAPI.setRequestHeaderFields(request: &urlRequest, ftxAuth: ftxAuth)
            return urlRequest
        }
    }
    
    public var settings: NetworkRequestSettings
    
    // MARK: Private
    
    private let market: String
    
    private let ftxAuth: FTXAuth
    
    // MARK: - Lifecycle
    
    /// Creates a new `FTXListTriggerOrdersRequest` instance.
    ///
    /// - Parameters:
    ///   - market: `String`,  Restrict to cancelling orders only on this market. E.g.: "PAXG-PERP".
    ///   - ftxAuth: FTX authentication data.
    ///   - session: `URLSession`, default is `.shared`.
    ///   - settings: `NetworkRequestSettings`.
    public init(market: String,
                ftxAuth: FTXAuth,
                session: URLSession = .shared,
                settings: NetworkRequestSettings) {
        self.market = market
        self.ftxAuth = ftxAuth
        self.session = session
        self.settings = settings
    }
}

// MARK: - Network Request Protocol

public extension FTXListTriggerOrdersRequest {
    
    func decode(_ data: Data) throws -> DecodableModel {
        try JSONDecoder().decode(FTXTriggerOrders.self, from: data)
    }
}
