//
//  KucoinFuturesPositionListRequest.swift
//  
//
//  Created by Fernando Fernandes on 29.01.22.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import Logging

/// A **request** for the list of positions.
///
/// https://docs.kucoin.com/futures/#get-position-list
public struct KucoinFuturesPositionListRequest: NetworkRequest {

    // MARK: - Properties

    public typealias DecodableModel = KucoinFuturesPositionList

    public var logger: Logger {
        NetworkRequestLogger().default
    }

    public var session: URLSession

    public var request: URLRequest {
        get throws {
            let futuresPositionListResource = KucoinFuturesPositionListResource()
            var urlRequest = URLRequest(url: try futuresPositionListResource.url)
            urlRequest.httpMethod = HTTPMethod.GET.rawValue
            try KucoinAPI.setRequestHeaderFields(request: &urlRequest, kucoinAuth: kucoinAuth.futures)
            return urlRequest
        }
    }

    public var settings: NetworkRequestSettings

    // MARK: Private

    private let kucoinAuth: KucoinAuth

    // MARK: - Lifecycle

    /// Creates a new `KucoinFuturesAccountOverviewRequest` instance.
    ///
    /// - Parameters:
    ///   - session: `URLSession`, default is `.shared`.
    ///   - kucoinAuth: Kucoin authentication data.
    ///   - settings: `NetworkRequestSettings`.
    public init(session: URLSession = .shared,
                kucoinAuth: KucoinAuth,
                settings: NetworkRequestSettings) {
        self.session = session
        self.kucoinAuth = kucoinAuth
        self.settings = settings
    }
}

// MARK: - Network Request Protocol

public extension KucoinFuturesPositionListRequest {

    func decode(_ data: Data) throws -> DecodableModel {
        try JSONDecoder().decode(KucoinFuturesPositionList.self, from: data)
    }
}
