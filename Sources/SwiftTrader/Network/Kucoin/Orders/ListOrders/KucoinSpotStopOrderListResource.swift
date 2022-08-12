//
//  KucoinSpotStopOrderListResource.swift
//  
//
//  Created by Fernando Fernandes on 12.08.22.
//

import Foundation

/// The **resource** for requesting the list of current spot **stop** orders.
///
/// https://docs.kucoin.com/#list-stop-orders
public struct KucoinSpotStopOrderListResource: NetworkResource {

    // MARK: - Properties

    public var url: URL {
        get throws {
            let baseURLString = try KucoinAPI.Spot.baseURL()
            guard var urlComponents = URLComponents(string: baseURLString) else {
                throw NetworkRequestError.invalidURLString(urlString: baseURLString)
            }
            urlComponents.path = KucoinAPI.Spot.Path.stopOrder
            guard let url = urlComponents.url else {
                throw NetworkRequestError.invalidURLString(urlString: baseURLString)
            }
            return url
        }
    }
}
