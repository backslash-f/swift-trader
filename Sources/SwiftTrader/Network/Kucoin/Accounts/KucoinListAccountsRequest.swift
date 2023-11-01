//
//  KucoinListAccountsRequest.swift
//  
//
//  Created by Fernando Fernandes on 16.07.22.
//

import Foundation

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import Logging

/// A **request** for listing Kucoin accounts.
///
/// https://docs.kucoin.com/#list-accounts
public struct KucoinListAccountsRequest: NetworkRequest {

    // MARK: - Properties

    public typealias DecodableModel = KucoinSpotListAccountsResponse

    public var logger: Logger {
        NetworkRequestLogger().default
    }

    public var session: URLSession

    public var request: URLRequest {
        get throws {
            let accountsResource = KucoinListAccountsResource(currencySymbol: currencySymbol)
            var urlRequest = URLRequest(url: try accountsResource.url)
            urlRequest.httpMethod = HTTPMethod.GET.rawValue
            try KucoinAPI.setRequestHeaderFields(request: &urlRequest, kucoinAuth: kucoinAuth.spot)
            return urlRequest
        }
    }

    public var settings: NetworkRequestSettings

    // MARK: Private

    private let currencySymbol: CurrencySymbol

    private let kucoinAuth: KucoinAuth

    // MARK: - Lifecycle

    /// Creates a new `KucoinListAccountsRequest` instance.
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

public extension KucoinListAccountsRequest {

    func decode(_ data: Data) throws -> DecodableModel {
        try JSONDecoder().decode(KucoinSpotListAccountsResponse.self, from: data)
    }
}
