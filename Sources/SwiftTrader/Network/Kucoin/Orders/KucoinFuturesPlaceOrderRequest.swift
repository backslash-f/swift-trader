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
    
    public typealias DecodableModel = KucoinFuturesPlaceOrder
    
    public var logger: Logger {
        NetworkRequestLogger().default
    }
    
    public var session: URLSession
    
    public var request: URLRequest {
        get throws {
            let futuresPlaceOrderResource = KucoinFuturesPlaceOrderResource()
            var urlRequest = URLRequest(url: try futuresPlaceOrderResource.url)
            urlRequest.httpMethod = HTTPMethod.POST.rawValue
            
            #warning("TODO: This has to be parameterized")
            var json = [String:Any]()
            json["clientOid"] = UUID().uuidString
            json["side"] = "sell"
            json["symbol"] = "XBTUSDTM"
            json["type"] = "limit"
            json["stop"] = "down"
            json["stopPriceType"] = "TP"
            json["stopPrice"] = "44970"
            json["reduceOnly"] = true
            json["closeOrder"] = true
            json["price"] = "44970"
            
            do {
                let data = try JSONSerialization.data(withJSONObject: json, options: [])
                urlRequest.httpBody = data
                urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
                urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
            } catch {
                #warning("TODO: handle error")
                print("EEEERRRRRROOORRR")
            }
            try KucoinAPI.setRequestHeaderFields(request: &urlRequest, kucoinAuth: kucoinAuth)
            return urlRequest
        }
    }
    
    public var settings: NetworkRequestSettings
    
    // MARK: Private
    
    private let parameters: KucoinOrderParameters
    
    private let kucoinAuth: KucoinAuth
    
    // MARK: - Lifecycle
    
    /// Creates a new `KucoinFuturesPlaceOrdersRequest` instance.
    ///
    /// - Parameters:
    ///   - parameters: `KucoinOrderParameters` that defines an order.
    ///   - kucoinAuth: Kucoin authentication data.
    ///   - session: `URLSession`, default is `.shared`.
    ///   - settings: `NetworkRequestSettings`.
    public init(parameters: KucoinOrderParameters,
                kucoinAuth: KucoinAuth,
                session: URLSession = .shared,
                settings: NetworkRequestSettings) {
        self.parameters = parameters
        self.kucoinAuth = kucoinAuth
        self.session = session
        self.settings = settings
    }
}

// MARK: - Network Request Protocol

public extension KucoinFuturesPlaceOrdersRequest {
    
    func decode(_ data: Data) throws -> DecodableModel {
        try JSONDecoder().decode(KucoinFuturesPlaceOrder.self, from: data)
    }
}
