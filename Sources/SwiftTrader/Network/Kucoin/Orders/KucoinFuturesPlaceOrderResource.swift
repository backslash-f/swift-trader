//
//  KucoinFuturesPlaceOrderResource.swift
//
//
//  Created by Fernando Fernandes on 07.02.22.
//

import Foundation

/// The **resource** for placing an order.
///
/// https://docs.kucoin.com/futures/#place-an-order
public struct KucoinFuturesPlaceOrderResource: NetworkResource {
    
    // MARK: - Properties
    
    public var url: URL {
        get throws {
            let baseURLString = KucoinAPI.Futures.URL.base
            guard var urlComponents = URLComponents(string: baseURLString) else {
                throw NetworkRequestError.invalidURLString(urlString: baseURLString)
            }
            urlComponents.path = KucoinAPI.Futures.Path.orders
            guard let url = urlComponents.url else {
                throw NetworkRequestError.invalidURLString(urlString: baseURLString)
            }
            return url
        }
    }
    
    // MARK: Private
    
    #warning("TODO: change from orderStatus to whatever needs sending")
    private let orderStatus: KucoinOrderStatus
    
    // MARK: - Lifecycle
    
    /// Creates a new `KucoinFuturesPlaceOrderResource` instance.
    ///
    /// - Parameter orderStatus: `KucoinFuturesOrderStatus`.
    init(orderStatus: KucoinOrderStatus) {
        self.orderStatus = orderStatus
    }
}
