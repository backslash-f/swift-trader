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
            let futuresPlaceOrderResource = KucoinFuturesPlaceOrderResource(orderStatus: .active)
            var urlRequest = URLRequest(url: try futuresPlaceOrderResource.url)
            urlRequest.httpMethod = HTTPMethod.POST.rawValue
            
            #warning("TODO: This has to be parameterized")
            var json = [String:Any]()
            json["symbol"] = "XBTUSDM"
            json["price"] = "42000"
            json["closeOrder"] = true
            
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
    
    #warning("TODO: change from orderStatus to whatever needs sending")
    private let orderStatus: KucoinOrderStatus
    
    private let kucoinAuth: KucoinAuth
    
    // MARK: - Lifecycle
    
    /// Creates a new `KucoinFuturesPlaceOrdersRequest` instance.
    ///
    /// - Parameters:
    ///   - session: `URLSession`, default is `.shared`.
    ///   - orderStatus: `KucoinFuturesOrderStatus`, default is `.active`.
    ///   - kucoinAuth: Kucoin authentication data.
    ///   - settings: `NetworkRequestSettings`.
    public init(session: URLSession = .shared,
                orderStatus: KucoinOrderStatus = .active,
                kucoinAuth: KucoinAuth,
                settings: NetworkRequestSettings) {
        self.session = session
        self.orderStatus = orderStatus
        self.kucoinAuth = kucoinAuth
        self.settings = settings
    }
}

// MARK: - Network Request Protocol

public extension KucoinFuturesPlaceOrdersRequest {
    
    func decode(_ data: Data) throws -> DecodableModel {
        try JSONDecoder().decode(KucoinFuturesPlaceOrder.self, from: data)
    }
}
