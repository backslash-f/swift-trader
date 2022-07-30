//
//  KucoinGetAccountRequest.swift
//
//
//  Created by Fernando Fernandes on 30.07.22.
//

import Foundation

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import Logging

/// A **request** for getting a Kucoin account.
///
/// https://docs.kucoin.com/#get-an-account
public struct KucoinGetAccountRequest: NetworkRequest {
    
    // MARK: - Properties
    
    public typealias DecodableModel = KucoinSpotGetAccount
    
    public var logger: Logger {
        NetworkRequestLogger().default
    }
    
    public var session: URLSession
    
    public var request: URLRequest {
        get throws {
            let accountResource = KucoinGetAccountResource(accountID: accountID)
            var urlRequest = URLRequest(url: try accountResource.url)
            urlRequest.httpMethod = HTTPMethod.GET.rawValue
            try KucoinAPI.setRequestHeaderFields(request: &urlRequest, kucoinAuth: kucoinAuth.spot)
            return urlRequest
        }
    }
    
    public var settings: NetworkRequestSettings
    
    // MARK: Private
    
    private let accountID: String
    
    private let kucoinAuth: KucoinAuth
    
    // MARK: - Lifecycle
    
    /// Creates a new `KucoinListAccountsRequest` instance.
    ///
    /// - Parameters:
    ///   - accountID: `String`, the ID of the account.
    ///   - kucoinAuth: Kucoin authentication data.
    ///   - session: `URLSession`, default is `.shared`.
    ///   - settings: `NetworkRequestSettings`.
    public init(accountID: String,
                kucoinAuth: KucoinAuth,
                session: URLSession = .shared,
                settings: NetworkRequestSettings) {
        self.accountID = accountID
        self.kucoinAuth = kucoinAuth
        self.session = session
        self.settings = settings
    }
}

// MARK: - Network Request Protocol

public extension KucoinGetAccountRequest {
    
    func decode(_ data: Data) throws -> DecodableModel {
        try JSONDecoder().decode(KucoinSpotGetAccount.self, from: data)
    }
}
