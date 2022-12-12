//
//  BinanceSpotNewOrderRequest.swift
//  
//
//  Created by Fernando Fernandes on 04.12.22.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import Logging

/// The **request** for placing a new order (spot).
///
/// https://binance-docs.github.io/apidocs/spot/en/#new-order-trade
public struct BinanceSpotNewOrderRequest: NetworkRequest {
    
    // MARK: - Properties
    
    public typealias DecodableModel = BinanceSpotNewOrderResponse
    
    public var logger: Logger {
        NetworkRequestLogger().default
    }
    
    public var session: URLSession
    
    public var request: URLRequest {
        get throws {
            let spotNewOrderResource = BinanceSpotNewOrderResource()
            var urlRequest = URLRequest(url: try spotNewOrderResource.url)
            urlRequest.httpMethod = HTTPMethod.POST.rawValue
            
            // Parameters.
            let dataParameter = try createDataParameter(from: orderParameters)
            urlRequest.httpBody = dataParameter
            urlRequest.addValue(HTTPHeader.Value.urlEncoded, forHTTPHeaderField: HTTPHeader.Field.contentType)
            try BinanceAPI.setRequestHeaderFields(request: &urlRequest, binanceAuth: binanceAuth.spot)
            
#warning("TODO: Add signature - here?")
            
            return urlRequest
        }
    }
    
    public var settings: NetworkRequestSettings
    
    // MARK: Private
    
    private let orderParameters: BinanceSpotNewOrderParameters
    
    private let binanceAuth: BinanceAuth
    
    // MARK: - Lifecycle
    
    /// Creates a new `BinanceSpotNewOrdersRequest` instance.
    ///
    /// - Parameters:
    ///   - orderParameters: `BinanceSpotNewOrderParameters`, which define an order.
    ///   - binanceAuth: Binance authentication data.
    ///   - session: `URLSession`, default is `.shared`.
    ///   - settings: `NetworkRequestSettings`.
    public init(orderParameters: BinanceSpotNewOrderParameters,
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

public extension BinanceSpotNewOrderRequest {
    
    func decode(_ data: Data) throws -> DecodableModel {
        try JSONDecoder().decode(BinanceSpotNewOrderResponse.self, from: data)
    }
}

// MARK: - Private

private extension BinanceSpotNewOrderRequest {
    
    func createDataParameter(from orderParameters: BinanceSpotNewOrderParameters) throws -> Data {
        let symbolParameter = "\(BinanceSpotNewOrderParameterKey.symbol.rawValue)=\(orderParameters.symbol)"
        let sideParameter = "\(BinanceSpotNewOrderParameterKey.side.rawValue)=\(orderParameters.side)"
        let typeParameter = "\(BinanceSpotNewOrderParameterKey.type.rawValue)=\(orderParameters.type)"
        let quoteQtyParameter = "\(BinanceSpotNewOrderParameterKey.quoteOrderQty.rawValue)=\(orderParameters.quoteOrderQty)"
        
#warning("TODO: Add timestamp")
        
        // E.g.: "symbol=BTCUSDT&side=buy&type=market&quoteOrderQty=100.0"
        let stringParameter = "\(symbolParameter)&\(sideParameter)&\(typeParameter)&\(quoteQtyParameter)"
        
        if let dataParameter = stringParameter.data(using: .utf8) {
            return dataParameter
        } else {
            throw NetworkRequestError.invalidDataFromString(string: stringParameter)
        }
    }
}
