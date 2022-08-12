//
//  KucoinSpotOrdersListRequest.swift
//  
//
//  Created by Fernando Fernandes on 12.08.22.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import Logging

/// A **request** for the list of spot orders.
///
/// https://docs.kucoin.com/#list-orders
public struct KucoinSpotOrdersListRequest: NetworkRequest {

    // MARK: - Properties

    public typealias DecodableModel = KucoinSpotOrderListResponse

    public var logger: Logger {
        NetworkRequestLogger().default
    }

    public var session: URLSession

    public var request: URLRequest {
        get throws {
            let spotOrderListResource = KucoinSpotOrderListResource(orderStatus: orderStatus)
            var urlRequest = URLRequest(url: try spotOrderListResource.url)
            urlRequest.httpMethod = HTTPMethod.GET.rawValue
            try KucoinAPI.setRequestHeaderFields(request: &urlRequest, kucoinAuth: kucoinAuth.spot)
            return urlRequest
        }
    }

    public var settings: NetworkRequestSettings

    // MARK: Private

    private let orderStatus: KucoinOrderStatus

    private let kucoinAuth: KucoinAuth

    // MARK: - Lifecycle

    /// Creates a new `KucoinSpotOrdersListRequest` instance.
    ///
    /// - Parameters:
    ///   - orderStatus: `KucoinOrderStatus`, default is `.active`.
    ///   - kucoinAuth: Kucoin authentication data.
    ///   - session: `URLSession`, default is `.shared`.
    ///   - settings: `NetworkRequestSettings`.
    public init(orderStatus: KucoinOrderStatus = .active,
                kucoinAuth: KucoinAuth,
                session: URLSession = .shared,
                settings: NetworkRequestSettings) {
        self.orderStatus = orderStatus
        self.kucoinAuth = kucoinAuth
        self.session = session
        self.settings = settings
    }
}

// MARK: - Network Request Protocol

public extension KucoinSpotOrdersListRequest {

    func decode(_ data: Data) throws -> DecodableModel {
        try JSONDecoder().decode(KucoinSpotOrderListResponse.self, from: data)
    }
}

