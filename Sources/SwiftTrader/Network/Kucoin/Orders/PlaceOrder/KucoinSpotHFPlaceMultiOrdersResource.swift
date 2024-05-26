//
//  KucoinSpotHFPlaceMultiOrdersResource.swift
//
//
//  Created by Fernando Fernandes on 23.05.24.
//

import Foundation

/// The **resource** for placing an order.
///
/// https://www.kucoin.com/docs/rest/spot-trading/spot-hf-trade-pro-account/place-multiple-orders
public struct KucoinSpotHFPlaceMultiOrdersResource: NetworkResource {

    // MARK: - Properties

    public var url: URL {
        get throws {
            let baseURLString = try KucoinAPI.Spot.baseURL()
            guard var urlComponents = URLComponents(string: baseURLString) else {
                throw NetworkRequestError.invalidURLString(urlString: baseURLString)
            }
            urlComponents.path = KucoinAPI.Spot.Path.hfMultiOrders
            guard let url = urlComponents.url else {
                throw NetworkRequestError.invalidURLString(urlString: baseURLString)
            }
            return url
        }
    }
}
