//
//  FTXPlaceOrderResource.swift
//
//
//  Created by Fernando Fernandes on 08.03.22.
//

import Foundation

/// The **resource** for placing a trigger order.
///
/// https://docs.ftx.com/?python#place-trigger-order
public struct FTXPlaceOrderResource: NetworkResource {
    
    // MARK: - Properties
    
    public var url: URL {
        get throws {
            let baseURLString = FTXAPI.BaseURL.production
            guard var urlComponents = URLComponents(string: baseURLString) else {
                throw NetworkRequestError.invalidURLString(urlString: baseURLString)
            }
            urlComponents.path = FTXAPI.Path.conditionalOrders
            guard let url = urlComponents.url else {
                throw NetworkRequestError.invalidURLString(urlString: baseURLString)
            }
            return url
        }
    }
}
