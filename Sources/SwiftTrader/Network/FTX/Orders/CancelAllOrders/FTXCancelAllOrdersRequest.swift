//
//  FTXCancelAllOrdersRequest.swift
//  
//
//  Created by Fernando Fernandes on 09.03.22.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import Logging

/// The **request** for requesting the cancellation of all open orders of a given (contract) symbol.
///
/// https://docs.ftx.com/?python#cancel-all-orders
public struct FTXCancelAllOrdersRequest: NetworkRequest {
    
    // MARK: - Properties
    
    public typealias DecodableModel = FTXCancelOrder
    
    public var logger: Logger {
        NetworkRequestLogger().default
    }
    
    public var session: URLSession
    
    public var request: URLRequest {
        get throws {
            let cancelAllOrdersResource = FTXCancelAllOrdersResource()
            var urlRequest = URLRequest(url: try cancelAllOrdersResource.url)
            urlRequest.httpMethod = HTTPMethod.DELETE.rawValue
            
            // Parameters.
            let parametersJSON = createJSONParameters(from: cancelOrderParameters)
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
    
    private let cancelOrderParameters: FTXCancelOrderParameters
    
    private let ftxAuth: FTXAuth
    
    // MARK: - Lifecycle
    
    /// Creates a new `FTXCancelAllOrdersRequest` instance.
    ///
    /// - Parameters:
    ///   - cancelOrderParameters: `FTXCancelOrderParameters` that defines a cancel order request.
    ///   - ftxAuth: FTX authentication data.
    ///   - session: `URLSession`, default is `.shared`.
    ///   - settings: `NetworkRequestSettings`.
    public init(cancelOrderParameters: FTXCancelOrderParameters,
                ftxAuth: FTXAuth,
                session: URLSession = .shared,
                settings: NetworkRequestSettings) {
        self.cancelOrderParameters = cancelOrderParameters
        self.ftxAuth = ftxAuth
        self.session = session
        self.settings = settings
    }
}

// MARK: - Network Request Protocol

public extension FTXCancelAllOrdersRequest {
    
    func decode(_ data: Data) throws -> DecodableModel {
        try JSONDecoder().decode(FTXCancelOrder.self, from: data)
    }
}

// MARK: - Private

private extension FTXCancelAllOrdersRequest {
    
    func createJSONParameters(from cancelOrderParameters: FTXCancelOrderParameters) -> [String: Any] {
        [
            FTXCancelOrderParameterKey.market.rawValue: cancelOrderParameters.market,
            FTXCancelOrderParameterKey.side.rawValue: cancelOrderParameters.side.rawValue,
            FTXCancelOrderParameterKey.conditionalOrdersOnly.rawValue: cancelOrderParameters.conditionalOrdersOnly,
            FTXCancelOrderParameterKey.limitOrdersOnly.rawValue: cancelOrderParameters.limitOrdersOnly
        ]
    }
}
