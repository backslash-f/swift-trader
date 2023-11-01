//
//  KucoinFuturesOrdersListRequest.swift
//  
//
//  Created by Fernando Fernandes on 29.01.22.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import Logging

/// A **request** for the list of orders.
///
/// https://docs.kucoin.com/futures/#get-order-list
public struct KucoinFuturesOrdersListRequest: NetworkRequest {

    // MARK: - Properties

    public typealias DecodableModel = KucoinFuturesOrderList

    public var logger: Logger {
        NetworkRequestLogger().default
    }

    public var session: URLSession

    public var request: URLRequest {
        get throws {
            let futuresOrderListResource = KucoinFuturesOrderListResource(orderStatus: orderStatus)
            var urlRequest = URLRequest(url: try futuresOrderListResource.url)
            urlRequest.httpMethod = HTTPMethod.GET.rawValue
            try KucoinAPI.setRequestHeaderFields(request: &urlRequest, kucoinAuth: kucoinAuth.futures)
            return urlRequest
        }
    }

    public var settings: NetworkRequestSettings

    // MARK: Private

    private let orderStatus: KucoinOrderStatus

    private let kucoinAuth: KucoinAuth

    // MARK: - Lifecycle

    /// Creates a new `KucoinFuturesOrdersListRequest` instance.
    ///
    /// - Parameters:
    ///   - orderStatus: `KucoinFuturesOrderStatus`, default is `.active`.
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

public extension KucoinFuturesOrdersListRequest {

    func decode(_ data: Data) throws -> DecodableModel {
        try JSONDecoder().decode(KucoinFuturesOrderList.self, from: data)
    }
}
