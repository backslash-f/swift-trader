//
//  BinanceSpotNewOrderResource.swift
//  
//
//  Created by Fernando Fernandes on 03.12.22.
//

import Foundation

/// The **resource** for placing an order.
///
/// https://binance-docs.github.io/apidocs/spot/en/#new-order-trade
public struct BinanceSpotNewOrderResource: NetworkResource {
    
    // MARK: - Properties
    
    public var url: URL {
        get throws {
            let baseURLString = try BinanceAPI.Spot.baseURL()
            guard var urlComponents = URLComponents(string: baseURLString) else {
                throw NetworkRequestError.invalidURLString(urlString: baseURLString)
            }
            urlComponents.path = BinanceAPI.Spot.Path.newOrder
            guard let url = urlComponents.url else {
                throw NetworkRequestError.invalidURLString(urlString: baseURLString)
            }
            return url
        }
    }
}
