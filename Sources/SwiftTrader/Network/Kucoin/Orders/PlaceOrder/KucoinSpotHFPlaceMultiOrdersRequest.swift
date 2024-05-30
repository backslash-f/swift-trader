//
//  KucoinSpotHFPlaceMultiOrdersRequest.swift
//
//
//  Created by Fernando Fernandes on 23.05.24.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import Logging

/// The **request** for placing an order (spot).
///
/// https://www.kucoin.com/docs/rest/spot-trading/spot-hf-trade-pro-account/place-multiple-orders
public struct KucoinSpotHFPlaceMultiOrdersRequest: NetworkRequest {

    // MARK: - Properties

    public typealias DecodableModel = KucoinHFPlaceMultiOrdersResponse

    public var logger: Logger {
        NetworkRequestLogger().default
    }

    public var session: URLSession

    public var request: URLRequest {
        get throws {
            let placeMultiOrdersResource = KucoinSpotHFPlaceMultiOrdersResource()
            var urlRequest = URLRequest(url: try placeMultiOrdersResource.url)
            urlRequest.httpMethod = HTTPMethod.POST.rawValue

            // Parameters.
            let parametersJSON = createJSONParameters(from: orders)
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

    private let orders: [KucoinSpotHFOrderParameters]

    private let kucoinAuth: KucoinAuth

    // MARK: - Lifecycle

    /// Creates a new `KucoinSpotHFPlaceMultiOrdersRequest` instance.
    ///
    /// - Parameters:
    ///   - orders: A `KucoinSpotHFOrderParameters` array; each element of it defines an order.
    ///   - kucoinAuth: Kucoin authentication data.
    ///   - session: `URLSession`, default is `.shared`.x
    ///   - settings: `NetworkRequestSettings`.
    public init(orders: [KucoinSpotHFOrderParameters],
                kucoinAuth: KucoinAuth,
                session: URLSession = .shared,
                settings: NetworkRequestSettings) {
        self.orders = orders
        self.kucoinAuth = kucoinAuth
        self.session = session
        self.settings = settings
    }
}

// MARK: - Network Request Protocol

public extension KucoinSpotHFPlaceMultiOrdersRequest {

    func decode(_ data: Data) throws -> DecodableModel {
        try JSONDecoder().decode(KucoinHFPlaceMultiOrdersResponse.self, from: data)
    }
}

// MARK: - Private

private extension KucoinSpotHFPlaceMultiOrdersRequest {

    func createJSONParameters(from orders: [KucoinSpotHFOrderParameters]) -> [String: Any] {
        let ordersArray = orders.map {
            [
                KucoinOrderParameterKey.clientOid.rawValue: $0.clientOid,
                KucoinOrderParameterKey.symbol.rawValue: $0.symbol,
                KucoinOrderParameterKey.type.rawValue: $0.type.rawValue,
                KucoinOrderParameterKey.size.rawValue: $0.size,
                KucoinOrderParameterKey.price.rawValue: $0.price,
                KucoinOrderParameterKey.side.rawValue: $0.side.rawValue
            ]
        }

        return ["orderList": ordersArray]
    }
}
