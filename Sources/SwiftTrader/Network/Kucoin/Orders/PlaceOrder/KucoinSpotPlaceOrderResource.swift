//
//  KucoinSpotPlaceOrderResource.swift
//  
//
//  Created by Fernando Fernandes on 12.08.22.
//

import Foundation

/// The **resource** for placing an order.
///
/// https://docs.kucoin.com/#place-a-new-order
public struct KucoinSpotPlaceOrderResource: NetworkResource {

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
