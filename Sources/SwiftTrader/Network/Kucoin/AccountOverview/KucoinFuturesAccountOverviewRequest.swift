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
/// https://www.kucoin.com/docs/rest/funding/funding-overview/get-account-detail-futures
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
            try KucoinAPI.setRequestHeaderFields(request: &urlRequest, kucoinAuth: kucoinAuth.futures)
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
    /// - Parameters:
    ///   - currencySymbol: `CurrencySymbol`.
    ///   - kucoinAuth: Kucoin authentication data.
    ///   - session: `URLSession`, default is `.shared`.
    ///   - settings: `NetworkRequestSettings`.
    public init(currencySymbol: CurrencySymbol,
                kucoinAuth: KucoinAuth,
                session: URLSession = .shared,
                settings: NetworkRequestSettings) {
        self.currencySymbol = currencySymbol
        self.kucoinAuth = kucoinAuth
        self.session = session
        self.settings = settings
    }
}

// MARK: - Network Request Protocol

public extension KucoinFuturesAccountOverviewRequest {
    
    func decode(_ data: Data) throws -> DecodableModel {
        try JSONDecoder().decode(KucoinFuturesAccountOverview.self, from: data)
    }
}
