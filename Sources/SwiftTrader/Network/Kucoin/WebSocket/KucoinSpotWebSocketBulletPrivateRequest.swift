//
//  KucoinSpotWebSocketBulletPrivateRequest.swift
//
//
//  Created by Fernando Fernandes on 25.12.23.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import Logging

/// A **request** to obtain an authorized token for subscribing to private channels and messages via WebSocket.
///
/// https://bit.ly/kucoinPrivateConnectToken
public struct KucoinSpotWebSocketBulletPrivateRequest: NetworkRequest {

    // MARK: - Properties

    public typealias DecodableModel = KucoinWebSocketPrivateTokenResponse

    public var logger: Logger {
        NetworkRequestLogger().default
    }

    public var session: URLSession

    public var request: URLRequest {
        get throws {
            let spotWebSocketBulletPrivateResource = KucoinSpotWebSocketBulletPrivateResource()
            var urlRequest = URLRequest(url: try spotWebSocketBulletPrivateResource.url)
            urlRequest.httpMethod = HTTPMethod.POST.rawValue
            try KucoinAPI.setRequestHeaderFields(request: &urlRequest, kucoinAuth: kucoinAuth.spot)
            return urlRequest
        }
    }

    public var settings: NetworkRequestSettings

    // MARK: Private

    private let kucoinAuth: KucoinAuth

    // MARK: - Lifecycle

    /// Creates a new `KucoinSpotWebSocketBulletPrivateRequest` instance.
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

public extension KucoinSpotWebSocketBulletPrivateRequest {

    func decode(_ data: Data) throws -> DecodableModel {
        try JSONDecoder().decode(KucoinWebSocketPrivateTokenResponse.self, from: data)
    }
}
