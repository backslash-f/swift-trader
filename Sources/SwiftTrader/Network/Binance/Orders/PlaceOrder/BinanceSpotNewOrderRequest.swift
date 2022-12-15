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
            
            // Body parameters.
            let stringParameters = createStringParameters(from: orderParameters)
            let dataParameters = try createDataParameter(from: stringParameters)
            
            // Signature parameter.
            let stringSignature = try createSignature(for: dataParameters, binanceAuth: binanceAuth)
            let dataSignature = try createDataParameter(from: stringParameters + "&\(stringSignature)")
            
            // Add the parameters.
            urlRequest.httpBody = dataSignature
            
            // Add header fields.
            urlRequest.addValue(HTTPHeader.Value.urlEncoded, forHTTPHeaderField: HTTPHeader.Field.contentType)
            try BinanceAPI.setRequestHeaderFields(request: &urlRequest, binanceAuth: binanceAuth.spot)
            
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
    
    /// Creates the `String` parameters to be later added into the request body.
    ///
    /// For example: *symbol=BTCUSDT&side=buy&type=market&quoteOrderQty=100.0&timestamp=1670998246731*
    ///
    func createStringParameters(from orderParameters: BinanceSpotNewOrderParameters) -> String {
        let symbolParam     = "\(BinanceSpotNewOrderParameterKey.symbol.rawValue)=\(orderParameters.symbol)"
        let sideParam       = "\(BinanceSpotNewOrderParameterKey.side.rawValue)=\(orderParameters.side)"
        let typeParam       = "\(BinanceSpotNewOrderParameterKey.type.rawValue)=\(orderParameters.type)"
        let quoteQtyParam   = "\(BinanceSpotNewOrderParameterKey.quoteOrderQty.rawValue)=\(orderParameters.quoteOrderQty)"
        let timestampParam  = "\(BinanceSpotNewOrderParameterKey.timestamp.rawValue)=\(Date().timestampMilliseconds)"
    
        return "\(symbolParam)&\(sideParam)&\(typeParam)&\(quoteQtyParam)&\(timestampParam)"
    }
    
    /// Creates the `Data` parameter to be added into the request body via `urlRequest.httpBody = dataParameter`.
    func createDataParameter(from string: String) throws -> Data {
        if let data = string.data(using: .utf8) {
            return data
        } else {
            throw NetworkRequestError.invalidDataFromString(string: string)
        }
    }
    
    func createSignature(for data: Data, binanceAuth: BinanceAuth) throws -> String {
        let signature = try NetworkRequestSignee.createHMACSignature(for: data,
                                                                     secret: binanceAuth.spot.apiSecret,
                                                                     isHexString: true)
        let symbolParam = "\(BinanceSpotNewOrderParameterKey.signature.rawValue)=\(signature)"
        return symbolParam
    }
}
