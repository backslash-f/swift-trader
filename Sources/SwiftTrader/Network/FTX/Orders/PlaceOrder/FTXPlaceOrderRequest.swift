//
//  FTXPlaceOrderRequest.swift
//  
//
//  Created by Fernando Fernandes on 08.03.22.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import Logging

/// The **request** for placing a trigger order.
///
/// https://docs.ftx.com/?python#place-trigger-order
public struct FTXPlaceOrderRequest: NetworkRequest {
    
    // MARK: - Properties
    
    public typealias DecodableModel = FTXPlaceTriggerOrder
    
    public var logger: Logger {
        NetworkRequestLogger().default
    }
    
    public var session: URLSession
    
    public var request: URLRequest {
        get throws {
            let placeTriggerOrderResource = FTXPlaceOrderResource()
            var urlRequest = URLRequest(url: try placeTriggerOrderResource.url)
            urlRequest.httpMethod = HTTPMethod.POST.rawValue
            
            // Parameters
            let parametersJSON = createJSONParameters(from: orderParameters)
            do {
                let data = try JSONSerialization.data(withJSONObject: parametersJSON, options: [])
                urlRequest.httpBody = data
                urlRequest.addValue(HTTPHeader.Value.applicationJSON, forHTTPHeaderField: HTTPHeader.Field.contentType)
                urlRequest.addValue(HTTPHeader.Value.applicationJSON, forHTTPHeaderField: HTTPHeader.Field.accept)
            } catch {
                throw NetworkRequestError.invalidJSONParameters(error: error)
            }
            
            try FTXAPI.setRequestHeaderFields(request: &urlRequest, ftxAuth: ftxAuth)
            return urlRequest
        }
    }
    
    public var settings: NetworkRequestSettings
    
    // MARK: Private
    
    private let orderParameters: FTXTriggerOrderParameters
    
    private let ftxAuth: FTXAuth
    
    // MARK: - Lifecycle
    
    /// Creates a new `FTXPlaceOrderRequest` instance.
    ///
    /// - Parameters:
    ///   - orderParameters: `FTXTriggerOrderParameters`, which define a FTX trigger order.
    ///   - ftxAuth: FTX authentication data.
    ///   - session: `URLSession`, default is `.shared`.
    ///   - settings: `NetworkRequestSettings`.
    public init(orderParameters: FTXTriggerOrderParameters,
                ftxAuth: FTXAuth,
                session: URLSession = .shared,
                settings: NetworkRequestSettings) {
        self.orderParameters = orderParameters
        self.ftxAuth = ftxAuth
        self.session = session
        self.settings = settings
    }
}

// MARK: - Network Request Protocol

public extension FTXPlaceOrderRequest {
    
    func decode(_ data: Data) throws -> DecodableModel {
        try JSONDecoder().decode(FTXPlaceTriggerOrder.self, from: data)
    }
}

// MARK: - Private

private extension FTXPlaceOrderRequest {
    
    func createJSONParameters(from orderParameters: FTXTriggerOrderParameters) -> [String: Any] {
        [
            FTXTriggerOrderParameterKey.market.rawValue: orderParameters.market,
            FTXTriggerOrderParameterKey.side.rawValue: orderParameters.side.rawValue,
            FTXTriggerOrderParameterKey.size.rawValue: orderParameters.size,
            FTXTriggerOrderParameterKey.type.rawValue: orderParameters.type.rawValue,
            FTXTriggerOrderParameterKey.reduceOnly.rawValue: orderParameters.reduceOnly,
            FTXTriggerOrderParameterKey.retryUntilFilled.rawValue: orderParameters.retryUntilFilled,
            FTXTriggerOrderParameterKey.triggerPrice.rawValue: orderParameters.triggerPrice,
            FTXTriggerOrderParameterKey.orderPrice.rawValue: orderParameters.orderPrice
        ]
    }
}
