//
//  BinanceSpotPlaceOrderRequest.swift
//  
//
//  Created by Fernando Fernandes on 04.12.22.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import Logging

/// The **request** for placing an order (spot).
///
/// https://binance-docs.github.io/apidocs/spot/en/#new-order-trade
public struct BinanceSpotPlaceOrderRequest: NetworkRequest {
    
    // MARK: - Properties
    
    public typealias DecodableModel = BinanceNewOrderResponse
    
    public var logger: Logger {
        NetworkRequestLogger().default
    }
    
    public var session: URLSession
    
    public var request: URLRequest {
        get throws {
            let spotPlaceOrderResource = BinanceSpotPlaceOrderResource()
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
            
            try BinanceAPI.setRequestHeaderFields(request: &urlRequest, binanceAuth: binanceAuth.spot)
            return urlRequest
        }
    }
    
    public var settings: NetworkRequestSettings
    
    // MARK: Private
    
    private let orderParameters: BinanceSpotOrderParameters
    
    private let binanceAuth: BinanceAuth
    
    // MARK: - Lifecycle
    
    /// Creates a new `BinanceSpotPlaceOrdersRequest` instance.
    ///
    /// - Parameters:
    ///   - orderParameters: `BinanceSpotOrderParameters`, which define an order.
    ///   - binanceAuth: Binance authentication data.
    ///   - session: `URLSession`, default is `.shared`.
    ///   - settings: `NetworkRequestSettings`.
    public init(orderParameters: BinanceSpotOrderParameters,
                binanceAuth: BinanceAuth,
                session: URLSession = .shared,
                settings: NetworkRequestSettings) {
        self.orderParameters = orderParameters
        self.binanceAuth = binanceAuth
        self.session = session
        self.settings = settings
    }
}

// MARK: - Network Request Protocol

public extension BinanceSpotPlaceOrderRequest {
    
    func decode(_ data: Data) throws -> DecodableModel {
        try JSONDecoder().decode(BinanceNewOrderResponse.self, from: data)
    }
}

// MARK: - Private

private extension BinanceSpotPlaceOrderRequest {
    
    func createJSONParameters(from orderParameters: BinanceSpotOrderParameters) -> [String: Any] {
        [
            BinanceOrderParameterKey.symbol.rawValue: orderParameters.symbol
        ]
    }
}
