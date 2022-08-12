//
//  KucoinSpotPlaceOrderRequest.swift
//  
//
//  Created by Fernando Fernandes on 12.08.22.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import Logging

/// The **request** for placing an order (spot).
///
/// https://docs.kucoin.com/#place-a-new-order-2
public struct KucoinSpotPlaceOrdersRequest: NetworkRequest {

    // MARK: - Properties

    public typealias DecodableModel = KucoinPlaceOrderResponse

    public var logger: Logger {
        NetworkRequestLogger().default
    }

    public var session: URLSession

    public var request: URLRequest {
        get throws {
            let spotPlaceOrderResource = KucoinSpotPlaceOrderResource()
            var urlRequest = URLRequest(url: try spotPlaceOrderResource.url)
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

            try KucoinAPI.setRequestHeaderFields(request: &urlRequest, kucoinAuth: kucoinAuth.spot)
            return urlRequest
        }
    }

    public var settings: NetworkRequestSettings

    // MARK: Private

    private let orderParameters: KucoinSpotOrderParameters

    private let kucoinAuth: KucoinAuth

    // MARK: - Lifecycle

    /// Creates a new `KucoinSpotPlaceOrdersRequest` instance.
    ///
    /// - Parameters:
    ///   - orderParameters: `KucoinSpotOrderParameters`, which define an order.
    ///   - kucoinAuth: Kucoin authentication data.
    ///   - session: `URLSession`, default is `.shared`.
    ///   - settings: `NetworkRequestSettings`.
    public init(orderParameters: KucoinSpotOrderParameters,
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

public extension KucoinSpotPlaceOrdersRequest {

    func decode(_ data: Data) throws -> DecodableModel {
        try JSONDecoder().decode(KucoinPlaceOrderResponse.self, from: data)
    }
}

// MARK: - Private

private extension KucoinSpotPlaceOrdersRequest {

    func createJSONParameters(from orderParameters: KucoinSpotOrderParameters) -> [String: Any] {
        [
            KucoinOrderParameterKey.clientOid.rawValue: UUID().uuidString,
            KucoinOrderParameterKey.side.rawValue: orderParameters.side.rawValue,
            KucoinOrderParameterKey.symbol.rawValue: orderParameters.symbol,
            KucoinOrderParameterKey.type.rawValue: orderParameters.type.rawValue,
            KucoinOrderParameterKey.stop.rawValue: orderParameters.stop.rawValue,
            KucoinOrderParameterKey.stopPrice.rawValue: orderParameters.stopPrice,
            KucoinOrderParameterKey.price.rawValue: orderParameters.price,
            KucoinOrderParameterKey.size.rawValue: orderParameters.size
        ]
    }
}
