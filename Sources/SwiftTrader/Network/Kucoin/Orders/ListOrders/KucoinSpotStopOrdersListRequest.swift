//
//  KucoinSpotStopOrdersListRequest.swift
//  
//
//  Created by Fernando Fernandes on 12.08.22.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import Logging

/// A **request** for the list of spot **stop** orders.
///
/// https://docs.kucoin.com/#list-stop-orders
public struct KucoinSpotStopOrdersListRequest: NetworkRequest {

    // MARK: - Properties

    public typealias DecodableModel = KucoinSpotStopOrderListResponse

    public var logger: Logger {
        NetworkRequestLogger().default
    }

    public var session: URLSession

    public var request: URLRequest {
        get throws {
            let spotStopOrderListResource = KucoinSpotStopOrderListResource()
            var urlRequest = URLRequest(url: try spotStopOrderListResource.url)
            urlRequest.httpMethod = HTTPMethod.GET.rawValue
            try KucoinAPI.setRequestHeaderFields(request: &urlRequest, kucoinAuth: kucoinAuth.spot)
            return urlRequest
        }
    }

    public var settings: NetworkRequestSettings

    // MARK: Private

    private let kucoinAuth: KucoinAuth

    // MARK: - Lifecycle

    /// Creates a new `KucoinSpotOrdersListRequest` instance.
    ///
    /// - Parameters:
    ///   - kucoinAuth: Kucoin authentication data.
    ///   - session: `URLSession`, default is `.shared`.
    ///   - settings: `NetworkRequestSettings`.
    public init(kucoinAuth: KucoinAuth,
                session: URLSession = .shared,
                settings: NetworkRequestSettings) {
        self.kucoinAuth = kucoinAuth
        self.session = session
        self.settings = settings
    }
}

// MARK: - Network Request Protocol

public extension KucoinSpotStopOrdersListRequest {

    func decode(_ data: Data) throws -> DecodableModel {
        try JSONDecoder().decode(KucoinSpotStopOrderListResponse.self, from: data)
    }
}

