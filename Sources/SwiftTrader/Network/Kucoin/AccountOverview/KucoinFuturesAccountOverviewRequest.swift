//
//  KucoinFuturesAccountOverviewRequest.swift
//  
//
//  Created by Fernando Fernandes on 29.01.22.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import Logging

/// A **request** for an overview of a Kucoin Futures account.
///
/// https://docs.kucoin.com/futures/#account
public struct KucoinFuturesAccountOverviewRequest: NetworkRequest {

    // MARK: - Properties
    
    public typealias DecodableModel = KucoinFuturesAccountOverview
    
    public var logger: Logger {
        NetworkRequestLogger().default
    }
    
    public var session: URLSession
    
    public var request: URLRequest {
        get throws {
            let futuresAccountOverviewResource = KucoinFuturesAccountOverviewResource(currencySymbol: currencySymbol)
            var urlRequest = URLRequest(url: try futuresAccountOverviewResource.url)
            urlRequest.httpMethod = HTTPMethod.GET.rawValue
            try KucoinAPI.setRequestHeaderFields(request: &urlRequest, kucoinAuth: kucoinAuth)
            return urlRequest
        }
    }
    
    public var settings: NetworkRequestSettings
    
    // MARK: Private
    
    private let currencySymbol: CurrencySymbol
    
    private let kucoinAuth: KucoinAuth
    
    // MARK: - Lifecycle
    
    /// Creates a new `KucoinFuturesAccountOverviewRequest` instance.
    ///
    /// - Parameter session: `URLSession` instance, the default is `.shared`.
    public init(session: URLSession = .shared,
                currencySymbol: CurrencySymbol = .USDT,
                kucoinAuth: KucoinAuth,
                settings: NetworkRequestSettings) {
        self.session = session
        self.currencySymbol = currencySymbol
        self.kucoinAuth = kucoinAuth
        self.settings = settings
    }
}

// MARK: - Network Request Protocol

public extension KucoinFuturesAccountOverviewRequest {
    
    func decode(_ data: Data) throws -> DecodableModel {
        try JSONDecoder().decode(KucoinFuturesAccountOverview.self, from: data)
    }
}
