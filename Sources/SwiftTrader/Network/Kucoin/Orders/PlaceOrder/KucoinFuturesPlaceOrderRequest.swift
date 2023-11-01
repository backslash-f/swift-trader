//
//  KucoinFuturesPlaceOrdersRequest.swift
//  
//
//  Created by Fernando Fernandes on 07.02.22.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import Logging

/// The **request** for placing an order.
///
/// https://docs.kucoin.com/futures/#place-an-order
public struct KucoinFuturesPlaceOrdersRequest: NetworkRequest {

    // MARK: - Properties

    public typealias DecodableModel = KucoinPlaceOrderResponse

    public var logger: Logger {
        NetworkRequestLogger().default
    }

    public var session: URLSession

    public var request: URLRequest {
        get throws {
            let futuresPlaceOrderResource = KucoinFuturesPlaceOrderResource()
            var urlRequest = URLRequest(url: try futuresPlaceOrderResource.url)
            urlRequest.httpMethod = HTTPMethod.POST.rawValue

            // Parameters.
            let parametersJSON = createJSONParameters(from: orderParameters)
            do {
                let data = try JSONSerialization.data(withJSONObject: parametersJSON, options: [])
                urlRequest.httpBody = data
                urlRequest.addValue(HTTPHeader.Value.applicationJSON, forHTTPHeaderField: HTTPHeader.Field.contentType)
                urlRequest.addValue(HTTPHeader.Value.applicationJSON, forHTTPHeaderField: HTTPHeader.Field.accept)
            } catch {
                throw NetworkRequestError.invalidJSONParameters(error: error)
            }

            try KucoinAPI.setRequestHeaderFields(request: &urlRequest, kucoinAuth: kucoinAuth.futures)
            return urlRequest
        }
    }

    public var settings: NetworkRequestSettings

    // MARK: Private

    private let orderParameters: KucoinFuturesOrderParameters

    private let kucoinAuth: KucoinAuth

    // MARK: - Lifecycle

    /// Creates a new `KucoinFuturesPlaceOrdersRequest` instance.
    ///
    /// - Parameters:
    ///   - orderParameters: `KucoinFuturesOrderParameters`, which define an order.
    ///   - kucoinAuth: Kucoin authentication data.
    ///   - session: `URLSession`, default is `.shared`.
    ///   - settings: `NetworkRequestSettings`.
    public init(orderParameters: KucoinFuturesOrderParameters,
                kucoinAuth: KucoinAuth,
                session: URLSession = .shared,
                settings: NetworkRequestSettings) {
        self.orderParameters = orderParameters
        self.kucoinAuth = kucoinAuth
        self.session = session
        self.settings = settings
    }
}

// MARK: - Network Request Protocol

public extension KucoinFuturesPlaceOrdersRequest {

    func decode(_ data: Data) throws -> DecodableModel {
        try JSONDecoder().decode(KucoinPlaceOrderResponse.self, from: data)
    }
}

// MARK: - Private

private extension KucoinFuturesPlaceOrdersRequest {

    func createJSONParameters(from orderParameters: KucoinFuturesOrderParameters) -> [String: Any] {
        [
            KucoinOrderParameterKey.clientOid.rawValue: UUID().uuidString,
            KucoinOrderParameterKey.symbol.rawValue: orderParameters.symbol,
            KucoinOrderParameterKey.side.rawValue: orderParameters.side.rawValue,
            KucoinOrderParameterKey.type.rawValue: orderParameters.type.rawValue,
            KucoinOrderParameterKey.stop.rawValue: orderParameters.stop.rawValue,
            KucoinOrderParameterKey.stopPriceType.rawValue: orderParameters.stopPriceType.rawValue,
            KucoinOrderParameterKey.stopPrice.rawValue: orderParameters.stopPrice,
            KucoinOrderParameterKey.price.rawValue: orderParameters.price,
            KucoinOrderParameterKey.reduceOnly.rawValue: orderParameters.reduceOnly,
            KucoinOrderParameterKey.closeOrder.rawValue: orderParameters.closeOrder
        ]
    }
}
