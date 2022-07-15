//
//  KucoinFuturesOrderListResource.swift
//
//
//  Created by Fernando Fernandes on 04.02.22.
//

import Foundation

/// The **resource** for requesting the list of current orders.
///
/// https://docs.kucoin.com/futures/#get-order-list
public struct KucoinFuturesOrderListResource: NetworkResource {
    
    // MARK: - Properties
    
    public var url: URL {
        get throws {
            let baseURLString = try KucoinAPI.Futures.baseURL()
            guard var urlComponents = URLComponents(string: baseURLString) else {
                throw NetworkRequestError.invalidURLString(urlString: baseURLString)
            }
            urlComponents.path = KucoinAPI.Futures.Path.orders
            let queryItems = [
                URLQueryItem(name: KucoinAPI.QueryParam.orderStatus, value: orderStatus.rawValue)
            ]
            urlComponents.queryItems = queryItems
            guard let url = urlComponents.url else {
                throw NetworkRequestError.invalidURLString(urlString: baseURLString)
            }
            return url
        }
    }
    
    // MARK: Private
    
    private let orderStatus: KucoinOrderStatus
    
    // MARK: - Lifecycle
    
    /// Creates a new `KucoinFuturesOrderListResource` instance.
    ///
    /// - Parameter orderStatus: `KucoinFuturesOrderStatus`.
    init(orderStatus: KucoinOrderStatus) {
        self.orderStatus = orderStatus
    }
}
