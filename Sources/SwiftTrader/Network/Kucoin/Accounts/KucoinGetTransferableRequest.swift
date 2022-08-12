//
//  KucoinGetTransferableRequest.swift
//  
//
//  Created by Fernando Fernandes on 11.08.22.
//

import Foundation

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import Logging

/// A **request** for getting the transferable balance of a specified account.
///
/// https://docs.kucoin.com/#get-the-transferable
public struct KucoinGetTransferableRequest: NetworkRequest {

    // MARK: - Properties

    public typealias DecodableModel = KucoinSpotGetTransferableResponse

    public var logger: Logger {
        NetworkRequestLogger().default
    }

    public var session: URLSession

    public var request: URLRequest {
        get throws {
            let accountsResource = KucoinGetTransferableResource(currencySymbol: currencySymbol,
                                                                 accountType: accountType)
            var urlRequest = URLRequest(url: try accountsResource.url)
            urlRequest.httpMethod = HTTPMethod.GET.rawValue
            try KucoinAPI.setRequestHeaderFields(request: &urlRequest, kucoinAuth: kucoinAuth.spot)
            return urlRequest
        }
    }

    public var settings: NetworkRequestSettings

    // MARK: Private

    private let currencySymbol: CurrencySymbol
    private let accountType: KucoinAccountType
    private let kucoinAuth: KucoinAuth

    // MARK: - Lifecycle

    /// Creates a new `KucoinGetTransferableRequest` instance.
    ///
    /// - Parameters:
    ///   - currencySymbol: `CurrencySymbol`.
    ///   - accountType: `KucoinAccountType`. Default is `.trade`.
    ///   - kucoinAuth: Kucoin authentication data.
    ///   - session: `URLSession`, default is `.shared`.
    ///   - settings: `NetworkRequestSettings`.
    public init(currencySymbol: CurrencySymbol,
                accountType: KucoinAccountType = .trade,
                kucoinAuth: KucoinAuth,
                session: URLSession = .shared,
                settings: NetworkRequestSettings) {
        self.currencySymbol = currencySymbol
        self.accountType = accountType
        self.kucoinAuth = kucoinAuth
        self.session = session
        self.settings = settings
    }
}

// MARK: - Network Request Protocol

public extension KucoinGetTransferableRequest {

    func decode(_ data: Data) throws -> DecodableModel {
        try JSONDecoder().decode(KucoinSpotGetTransferableResponse.self, from: data)
    }
}
