//
//  KucoinSpotCancelOrdersRequest.swift
//  
//
//  Created by Fernando Fernandes on 12.08.22.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import Logging

/// A **request** for cancelling all untriggered stop orders of a given (contract) symbol.
///
/// https://docs.kucoin.com/#cancel-orders
public struct KucoinSpotCancelOrdersRequest: NetworkRequest {

    // MARK: - Properties

    public typealias DecodableModel = KucoinCancelStopOrdersResponse

    public var logger: Logger {
        NetworkRequestLogger().default
    }

    public var session: URLSession

    public var request: URLRequest {
        get throws {
            let spotCancelOrdersResource = KucoinSpotCancelOrdersResource(symbol: symbol)
            var urlRequest = URLRequest(url: try spotCancelOrdersResource.url)
            urlRequest.httpMethod = HTTPMethod.DELETE.rawValue
            try KucoinAPI.setRequestHeaderFields(request: &urlRequest, kucoinAuth: kucoinAuth.spot)
            return urlRequest
        }
    }

    public var settings: NetworkRequestSettings

    // MARK: Private

    private let symbol: String

    private let kucoinAuth: KucoinAuth

    // MARK: - Lifecycle

    /// Creates a new `KucoinSpotCancelOrdersRequest` instance.
    ///
    /// - Parameters:
    ///   - symbol: `String`, represents the specific contract for which all the untriggered stop orders will be cancelled.
    ///   E.g.: "BTC-USDT".
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

public extension KucoinSpotCancelOrdersRequest {

    func decode(_ data: Data) throws -> DecodableModel {
        try JSONDecoder().decode(KucoinCancelStopOrdersResponse.self, from: data)
    }
}
