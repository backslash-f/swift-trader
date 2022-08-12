//
//  KucoinSpotOrderListResource.swift
//  
//
//  Created by Fernando Fernandes on 12.08.22.
//

import Foundation

/// The **resource** for requesting the list of current spot orders.
///
/// https://docs.kucoin.com/#list-orders
public struct KucoinSpotOrderListResource: NetworkResource {

    // MARK: - Properties

    public var url: URL {
        get throws {
            let baseURLString = try KucoinAPI.Spot.baseURL()
            guard var urlComponents = URLComponents(string: baseURLString) else {
                throw NetworkRequestError.invalidURLString(urlString: baseURLString)
            }
            urlComponents.path = KucoinAPI.Spot.Path.orders
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

    /// Creates a new `KucoinSpotOrderListResource` instance.
    ///
    /// - Parameter orderStatus: `KucoinOrderStatus`.
    init(orderStatus: KucoinOrderStatus) {
        self.orderStatus = orderStatus
    }
}
