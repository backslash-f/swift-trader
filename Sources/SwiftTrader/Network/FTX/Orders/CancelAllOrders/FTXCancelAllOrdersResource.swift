//
//  FTXCancelAllOrdersResource.swift
//
//
//  Created by Fernando Fernandes on 09.03.22.
//

import Foundation

/// The **resource** for requesting the cancellation of all open orders of a given (contract) symbol.
///
/// https://docs.ftx.com/?python#cancel-all-orders
public struct FTXCancelAllOrdersResource: NetworkResource {
    
    // MARK: - Properties
    
    public var url: URL {
        get throws {
            let baseURLString = FTXAPI.BaseURL.production
            guard var urlComponents = URLComponents(string: baseURLString) else {
                throw NetworkRequestError.invalidURLString(urlString: baseURLString)
            }
            urlComponents.path = FTXAPI.Path.orders
            guard let url = urlComponents.url else {
                throw NetworkRequestError.invalidURLString(urlString: baseURLString)
            }
            return url
        }
    }
}
